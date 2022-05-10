Assert  = require \assert
Chalk   = require \chalk
Choki   = require \chokidar
Cp      = require \child_process
Emitter = require \events .EventEmitter
Fs      = require \fs
_       = require \lodash
Path    = require \path
Shell   = require \shelljs/global
Dirname = require \./constants .dirname
Dir     = require \./constants .dir
G       = require \./growl

const CFG = "#{Dir.SRC}/task/lint"
const MOD = "#{Dir.BUILD}/node_modules"

tasks =
  livescript:
    bin : \ls-lint
    cfg : \ls-lint.lson
    glob: true
    ixt : \ls
    opts: ''
  pug:
    bin : \pug-lint
    cfg : \.pug-lintrc.js
    glob: false
    ixt : \pug
    opts: ''
  stylus:
    bin : \stylelint
    cfg : \.stylelintrc.js
    glob: true
    ixt : \styl
    opts: "--config-basedir #MOD --custom-syntax #MOD/stylelint-plugin-stylus/custom-syntax"

module.exports = me = (new Emitter!) with
  all: ->
    for tid of tasks then
      t = tasks[tid]
      if t.glob then lint-glob t else lint-batch t

  start: ->
    log Chalk.green 'start lint'
    try
      pushd Dir.SRC
      for tid of tasks then start-watching tid
    finally
      popd!

  stop: ->
    log Chalk.red 'stop lint'
    for , t of tasks then t.watcher?close!

## helpers

function get-cmd t, ipath-abs
  "#MOD/.bin/#{t.bin} --config #CFG/#{t.cfg} #{t.opts} '#{ipath-abs}'"  # must quote for glob

function lint t, ipath
  cmd = get-cmd t, Path.resolve(Dir.SRC, ipath)
  log Chalk.gray cmd
  try Cp.execSync cmd, stdio:\inherit catch err

function lint-batch t
  w = t.watcher.getWatched!
  files = [f for path, names of w for name in names
    when test \-f f = Path.resolve Dir.SRC, path, name]
  info = "#{files.length} #{t.ixt} files"
  G.say "linting #info..."
  for f in files then lint t, Path.relative(Dir.SRC, f)
  G.ok "...done #info!"

function lint-glob t
  cmd = get-cmd t, "#{Dir.SRC}/**/*.#{t.ixt}"
  log Chalk.gray cmd
  try Cp.execSync cmd, stdio:\inherit catch err

function start-watching tid
  log "start watching #tid"
  Assert.equal pwd!, Dir.SRC
  pat = (t = tasks[tid]).pat or "*.#{t.ixt}"
  dirs = "#{Dirname.SITE},#{Dirname.TASK}"
  w = t.watcher = Choki.watch ["{#dirs}/**/#pat" pat],
    cwd:Dir.SRC
    ignoreInitial:true
    ignored:t.ignore
    persistent: false
    usePolling: true  # see github chokidar issue 884
  w.on \all _.debounce process, 500ms, leading:true trailing:false

  function process act, ipath
    # log act, tid, ipath
    switch act
    | \add \change
      try lint t, ipath
      catch e then return G.err ipath
      G.ok
