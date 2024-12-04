Emitter = require \events .EventEmitter
Fs      = require \fs
Match   = require \minimatch .minimatch
P       = require \child_process
Path    = require \path
Sh      = require \shelljs
C       = require \./constants
Dirname = require \./constants .dirname
Dir     = require \./constants .dir
T       = require \./task

const TASKS = T.prepare RAW_TASKS =
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
    cmd: "yarn --silent pug3 -s -O #{C.VERSES_PATH} --out $OUT $IN"
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

module.exports = me = (new Emitter!) with
  all: ->>
    Sh.rm \-rf Dir.BUILD_SITE
    try await T.run-tasks TASKS; me.emit \restart catch err then log err; me.emit \error
  start: -> for , t of TASKS then start-watching t

function start-watching t
  log "start watching build #{t.tid}: #{t.srcdir}/#{t.pat}"
  watch-once!
  function watch-once then w = Fs.watch t.srcdir, {recursive:true}, (, path) ->>
    return unless Match path, t.pat
    w.close!; await new Promise -> setTimeout it, 20ms # stop event flood and wait for file updates to settle
    try
      if t.pid then await T.run-tasks [TASKS[t.pid]]
      else if Fs.existsSync ipath = Path.resolve t.srcdir, path then await T.run-task t, ipath
      me.emit if t.rsn then \restart else \built
    catch err then me.emit \error
    watch-once!
