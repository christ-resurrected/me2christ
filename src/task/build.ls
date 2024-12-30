Emitter = require \events .EventEmitter
Fs      = require \fs
C       = require \./constants
Dirname = require \./constants .dirname
Dir     = require \./constants .dir
T       = require \./task
Tpug    = require \./task-pug

const TASKS = T.init const _TASKS =
  json_ls:
    cmd: "yarn --silent lsc --output $ODIR $IN"
    dir: \.
    ixt: \json.ls
    ord: 1 # run first to avoid "Unexpected end of JSON input" error
  site_asset:
    cmd: "cp --target-directory $ODIR $IN"
    dir: "#{Dirname.SITE}/asset"
    ixt: '{png,svg}'
    ord: 2
    pat: '*/'
  site_pug:
    dir: Dirname.SITE
    fun: Tpug.render
    ixt: \pug
    ord: 2
  site_pug_include:
    dir: Dirname.SITE
    ixt: '{js,css}'
    pat: '**/'
    pid: \site_pug # parent task id to run
  site_pug_pug:
    dir: Dirname.SITE
    ixt: \pug
    pat: '*/' # subdir 1-level deep
    pid: \site_pug # parent task id to run
  task_ls:
    cmd: "yarn --silent lsc --output $ODIR $IN"
    dir: Dirname.TASK
    ixt: \ls
    ord: 2
    pat: '**/'
    rsn: true # restart node

module.exports = me = (new Emitter!) with
  all: ->>
    Fs.rmSync Dir.BUILD_SITE, {force:true, recursive:true}
    try
      for ord in [1,2] then await T.run-tasks {[tid, t] for tid, t of TASKS when t.ord is ord}
      me.emit \restart
    catch err then log err; me.emit \error
  start: -> for _, t of TASKS then T.start-watching \build, me, t
