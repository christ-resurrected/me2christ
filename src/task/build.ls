Emitter = require \events .EventEmitter
Sh      = require \shelljs
C       = require \./constants
Dirname = require \./constants .dirname
Dir     = require \./constants .dir
T       = require \./task

const TASKS = T.prepare const RAW_TASKS =
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
  start: -> for , t of TASKS then T.start-watching me, \build, t
