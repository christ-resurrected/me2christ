Chalk   = require \chalk
Emitter = require \events .EventEmitter
Fs      = require \fs
Glob    = require \glob .globSync
Match   = require \minimatch
P       = require \child_process
Path    = require \path
Dirname = require \./constants .dirname
Dir     = require \./constants .dir
G       = require \./growl

const CFG = "#{Dir.SRC}/task/lint"
const MOD = "#{Dir.BUILD}/node_modules"

tasks =
  # site_pug:
  #   cmd : \pug-lint
  #   cfg : \.pug-lintrc.js
  #   ixt : \pug
  site_scss:
    cmd : \stylelint
    cfg : \.stylelintrc.json
    ixt : \scss
    opts: "--config-basedir #MOD --custom-syntax #MOD/postcss-scss"
  task_ls:
    cmd : \ls-lint
    cfg : \ls-lint.lson
    ixt : \ls

for , t of tasks then
  t.pat = "**/*.#{t.ixt}"
  t.glob = Path.resolve Dir.SRC, t.pat

module.exports = me = (new Emitter!) with
  all: ->
    for , t of tasks then lint-batch t
    me.emit \done
  start: ->
    log Chalk.green 'start lint'
    for tid of tasks then start-watching tid
  stop: ->
    log Chalk.red 'stop lint'
    for , t of tasks then t.watcher?close!

## helpers

function lint t, ipath
  cmd = "yarn #{t.cmd} --config #CFG/#{t.cfg} #{t.opts || ''} #ipath"
  try P.execSync cmd, stdio:\inherit catch err

function lint-batch t
  files = Glob t.glob
  info = "#{files.length} #{t.ixt} files"
  G.say "linting #info..."
  for f in files then lint t, f
  G.ok "...done #info!"

function start-watching tid
  t = tasks[tid]
  log "start watching #tid: #{t.pat}"
  watch-once!
  function watch-once
    w = t.watcher = Fs.watch Dir.SRC, {recursive:true}, (e, path) ->
      return unless Match path, t.pat
      w.close!
      setTimeout process, 50ms # wait for events to settle
      function process
        if Fs.existsSync ipath = Path.resolve Dir.SRC, path then lint t, ipath
        setTimeout watch-once, 10ms
        me.emit \done
