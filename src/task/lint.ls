Emitter = require \events .EventEmitter
Dirname = require \./constants .dirname
Dir     = require \./constants .dir
T       = require \./task

const CONFIG_DIR = "#{Dir.SRC_TASK}/lint-config"

const TASKS = T.init const _TASKS =
  config:
    cmd: "cp --target-directory $ODIR $IN"
    dir: Dirname.TASK
    ixt: \lson
  lint_ls:
    cmd: "yarn --silent ls-lint --config #CONFIG_DIR/lint-ls.lson $IN"
    dir: Dirname.TASK
    ixt: \ls
    pat: '**/'
  lint_sss:
    cmd: "yarn --silent stylelint --customSyntax sugarss -c stylelint-config-recommended $IN"
    dir: Dirname.SITE
    ixt: \sss
    pat: '**/'

module.exports = me = (new Emitter!) with
  all: ->> try await T.run-tasks TASKS catch err then log err finally log \done; me.emit \done
  start: -> for _, t of TASKS then T.start-watching \lint, me, t
