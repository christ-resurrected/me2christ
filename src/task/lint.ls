Emitter = require \events .EventEmitter
Dirname = require \./constants .dirname
Dir     = require \./constants .dir
T       = require \./task

const TASKS = T.init const _TASKS =
  config:
    cmd: "cp --target-directory $OUT $IN"
    dir: Dirname.TASK
    ixt: \lson
  lint_ls:
    cmd: "yarn --silent ls-lint --config #{Dir.SRC_TASK}/lint-ls.lson $IN"
    dir: Dirname.TASK
    ixt: \ls
    pat: '**/'

module.exports = me = (new Emitter!) with
  all: ->> try await T.run-tasks TASKS; me.emit \done catch err then log err
  start: -> for _, t of TASKS then T.start-watching \lint, me, t
