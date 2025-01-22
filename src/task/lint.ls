Emitter = require \events .EventEmitter
Dirname = require \./constants .dirname
Dir     = require \./constants .dir
T       = require \./task

const CONFIG_DIR = "#{Dir.SRC_TASK}/lint-config"

const TASKS = T.init const _TASKS =
  config:
    cmd: "cp --target-directory $ODIR $IN"
    dir: Dirname.TASK
    pat: '**/*.{lson,yml}'
  lint_html:
    cmd: "yarn --silent html-validate $IN"
    dir: Dir.BUILD_SITE
    pat: \*.html
  lint_ls:
    cmd: "yarn --silent ls-lint --config #CONFIG_DIR/lint-ls.lson $IN"
    dir: Dirname.TASK
    pat: \**/*.ls
  lint_sss:
    cmd: "yarn --silent stylelint -c #CONFIG_DIR/stylelint.yml $IN"
    dir: Dirname.SITE
    pat: \**/*.sss

module.exports = me = (new Emitter!) with
  all: ->> try await T.run-tasks TASKS catch err then log err finally me.emit \done
  start: -> for _, t of TASKS then T.start-watching \lint, me, t
