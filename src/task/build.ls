Assert  = require \assert
Chalk   = require \chalk
Glob    = require \glob .globSync
Emitter = require \events .EventEmitter
Fs      = require \fs
Match   = require \minimatch
P       = require \child_process
Path    = require \path
Sh      = require \shelljs
Dirname = require \./constants .dirname
Dir     = require \./constants .dir

tasks =
  json_ls:
    cmd: "yarn lsc --output $OUT $IN"
    dir: \.
    ixt: \json.ls
    oxt: \json
  site_asset:
    cmd: "cp --target-directory $OUT $IN"
    dir: "#{Dirname.SITE}/asset/tract"
    ixt: \png
  site_pug:
    cmd: "yarn pug3 -O \"{version:'#{process.env.npm_package_version}'}\" --out $OUT $IN"
    dir: Dirname.SITE
    ixt: \pug
    oxt: \html
  site_pug_includes:
    dir: Dirname.SITE
    ixt: '{js,pug,scss}'
    pat: '*/' # subdir 1-level deep
    pid: \site_pug # parent task id to run
  task_lint:
    cmd: "cp --target-directory $OUT $IN"
    dir: "#{Dirname.TASK}/lint"
    ixt: '{js,json,lson}'
  task_ls:
    cmd: "yarn lsc --output $OUT $IN"
    dir: Dirname.TASK
    ixt: \ls
    oxt: \js
    pat: '**/'
    rsn: true # restart node

for tid, t of tasks then
  t.tid = tid
  t.pat = (t.pat || '') + "*.#{t.ixt}"
  t.srcdir = Path.resolve Dir.SRC, t.dir
  t.glob = Path.resolve t.srcdir, t.pat

module.exports = me = (new Emitter!) with
  all: ->>
    Sh.rm \-rf Dir.build.SITE
    try await run-tasks tasks; me.emit \restart
    catch err then log \x; me.emit \error
  start: ->
    log Chalk.green 'start build'
    for , t of tasks then start-watching t
  stop: ->
    log Chalk.red 'stop build'
    for , t of tasks then t.watcher?close!

## helpers

function get-opath t, ipath
  ipath.replace t.ixt, t.oxt if t.oxt
  Path.resolve Dir.BUILD, Path.relative Dir.SRC, ipath

function run-task t, ipath then new Promise (resolve, reject) ->
  Sh.mkdir \-p odir = Path.dirname opath = get-opath t, ipath
  log Chalk.blue cmd = t.cmd.replace(\$IN ipath).replace(\$OUT odir).replace(\$OPATH opath)
  P.exec cmd, (err, stdout, stderr) -> if err then log stderr; reject! else log stdout if stdout.length; resolve!

async function run-tasks tasks
  await Promise.all promises = [for , t of tasks when t.cmd then for f in Glob(t.glob) then run-task t, f].flat!.flat!
  log Chalk.green "...done #{promises.length} files!"

function start-watching t
  log "start watching #{t.tid}: #{t.srcdir}/#{t.pat}"
  watch-once!
  function watch-once then w = Fs.watch t.srcdir, {recursive:true}, (, path) ->>
    return unless Match path, t.pat
    w.close! # shutdown flood of events
    await new Promise (resolve) -> setTimeout resolve, 20ms # wait for background file updates to settle
    try
      if t.pid then await run-tasks [tasks[t.pid]]
      else if Fs.existsSync ipath = Path.resolve t.srcdir, path then await run-task t, ipath
      me.emit if t.rsn then \restart else \built
    catch err then me.emit \error
    watch-once!
