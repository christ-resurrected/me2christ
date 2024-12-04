Assert  = require \assert
Chalk   = require \chalk
Glob    = require \glob .globSync
Emitter = require \events .EventEmitter
Fs      = require \fs
Match   = require \minimatch .minimatch
P       = require \child_process
Path    = require \path
Sh      = require \shelljs
C       = require \./constants
Dirname = require \./constants .dirname
Dir     = require \./constants .dir

const TASKS =
  json_ls:
    cmd: "yarn lsc --output $OUT $IN"
    dir: \.
    ixt: \json.ls
    oxt: \json
  site_asset:
    cmd: "cp --target-directory $OUT $IN"
    dir: "#{Dirname.SITE}/asset"
    ixt: '{png,svg}'
    pat: '*/'
  site_pug:
    cmd: "yarn --silent pug3 -O #{C.VERSES_PATH} --out $OUT $IN"
    dir: Dirname.SITE
    ixt: \pug
    oxt: \html
  site_pug_includes:
    dir: Dirname.SITE
    ixt: '{css,js,pug}'
    pat: '*/' # subdir 1-level deep
    pid: \site_pug # parent task id to run
  task_lint:
    cmd: "cp --target-directory $OUT $IN"
    dir: "#{Dirname.TASK}/lint"
    ixt: '{lson}'
  task_ls:
    cmd: "yarn --silent lsc --output $OUT $IN"
    dir: Dirname.TASK
    ixt: \ls
    oxt: \js
    pat: '**/'
    rsn: true # restart node

for tid, t of TASKS then
  t.tid = tid
  t.pat = "#{t.pat || ''}*.#{t.ixt}"
  t.srcdir = Path.resolve Dir.SRC, t.dir
  t.glob = Path.resolve t.srcdir, t.pat

module.exports = me = (new Emitter!) with
  all: ->>
    Sh.rm \-rf Dir.BUILD_SITE
    try await run-tasks TASKS; me.emit \restart catch err then log err; me.emit \error
  start: -> for , t of TASKS then start-watching t

function run-task t, ipath then new Promise (resolve, reject) ->
  function get-opath then Path.resolve Dir.BUILD, Path.relative Dir.SRC, ipath.replace t.ixt, t.oxt || t.ixt
  Sh.mkdir \-p odir = Path.dirname opath = get-opath!
  log Chalk.blue cmd = t.cmd.replace(\$IN ipath).replace(\$OUT odir).replace(\$OPATH opath)
  P.exec cmd, (err, stdout, stderr) -> if err then log stderr; reject! else log stdout if stdout.length; resolve!

async function run-tasks tasks
  await Promise.all p = [run-task t, f for , t of tasks when t.cmd for f in Glob t.glob].flat!flat!
  log Chalk.green "...done #{p.length} files!"

function start-watching t
  log "start watching build #{t.tid}: #{t.srcdir}/#{t.pat}"
  watch-once!
  function watch-once then w = Fs.watch t.srcdir, {recursive:true}, (, path) ->>
    return unless Match path, t.pat
    w.close!; await new Promise -> setTimeout it, 20ms # stop event flood and wait for file updates to settle
    try
      if t.pid then await run-tasks [TASKS[t.pid]]
      else if Fs.existsSync ipath = Path.resolve t.srcdir, path then await run-task t, ipath
      me.emit if t.rsn then \restart else \built
    catch err then me.emit \error
    watch-once!
