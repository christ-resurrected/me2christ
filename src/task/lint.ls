Emitter = require \events .EventEmitter
Fs      = require \fs
Match   = require \minimatch .minimatch
Path    = require \path
Dirname = require \./constants .dirname
Dir     = require \./constants .dir
T       = require \./task

const TASKS = T.prepare RAW_TASKS =
  task_ls:
    cmd: "yarn --silent ls-lint --config #{Dir.SRC}/task/lint/ls-lint.lson $IN"
    dir: Dirname.TASK
    ixt: \ls
    pat: '**/'

module.exports = me = (new Emitter!) with
  all: ->> try T.run-tasks TASKS; me.emit \done catch err then log err
  start: -> for , t of TASKS then T.start-watching me, \lint, t
