Emitter = require \events .EventEmitter
Dirname = require \./constants .dirname
Dir     = require \./constants .dir
T       = require \./task

const CONFIG_DIR = "#{Dir.SRC_TASK}/lint-config"

const TASKS = T.init const _TASKS =
  html:
    cmd: "yarn --silent html-validate $IN"
    dir: Dir.BUILD_SITE
    pat: \*.html
  js:
    cmd: "yarn --silent eslint -c #CONFIG_DIR/eslintrc.json $IN"
    dir: Dir.SRC_SITE
    pat: \**/*.js
  ls:
    cmd: "yarn --silent ls-lint --config #CONFIG_DIR/lint-ls.lson $IN"
    dir: Dirname.TASK
    pat: \**/*.ls
  sss:
    cmd: "yarn --silent stylelint -c #CONFIG_DIR/stylelint.yml $IN"
    dir: Dirname.SITE
    pat: \**/*.sss

module.exports = me = (new Emitter!) with
  all: ->> try await T.run-tasks TASKS catch err then log err finally me.emit \done
  start: -> for _, t of TASKS then T.start-watching \lint, me, t
