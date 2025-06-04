E   = require \events
Dir = require \./constants .DIR
T   = require \./task

const CONFIG_DIR = "#{Dir.SRC_TASK}/lint-config"

const TASKS = T.init const _TASKS =
  html:
    cmd: "bun --silent html-validate -c #CONFIG_DIR/htmlvalidate.json $IN"
    dir: Dir.BUILD_SITE
    pat: \*.html
  js:
    cmd: "bun --silent eslint -c #CONFIG_DIR/eslintrc.json $IN"
    dir: Dir.SRC_SITE
    pat: \**/*.js
  ls:
    cmd: "bun --silent ls-lint --config #CONFIG_DIR/lint-ls.lson $IN"
    dir: Dir.SRC_TASK
    pat: \**/*.ls
  sss:
    cmd: "bun --silent stylelint -c #CONFIG_DIR/stylelint.yml $IN"
    dir: Dir.SRC_SITE
    pat: \**/*.sss

module.exports = me = (new E.EventEmitter!) with
  all: ->> try await T.run-tasks TASKS catch err then log err finally me.emit \done
  watch: -> for _, t of TASKS then T.watch \lint, me, t
