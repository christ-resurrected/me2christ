Emitter = require \events .EventEmitter
Fs      = require \fs
C       = require \./constants
Dirname = require \./constants .dirname
Dir     = require \./constants .dir
T       = require \./task

const TASKS = T.init const _TASKS =
  json_ls:
    cmd: "yarn --silent lsc --output $OUT $IN"
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
  task_ls:
    cmd: "yarn --silent lsc --output $OUT $IN"
    dir: Dirname.TASK
    ixt: \ls
    oxt: \js
    pat: '**/'
    rsn: true # restart node

const TASKS_ASYNC = {[tid, t] for tid, t of TASKS when tid isnt \json_ls}

module.exports = me = (new Emitter!) with
  all: ->>
    Fs.rmSync Dir.BUILD_SITE, {force:true, recursive:true}
    try
      await T.run-tasks json_ls:TASKS.json_ls # avoid "Unexpected end of JSON input" error
      await T.run-tasks TASKS_ASYNC
      me.emit \restart
    catch err then log err; me.emit \error
  start: -> for _, t of TASKS then T.start-watching \build, me, t
