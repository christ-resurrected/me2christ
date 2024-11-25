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

const BIN = "#{Dir.BUILD}/node_modules/.bin"

tasks =
  package_json_ls:
    pat: \package
    cmd: "#BIN/lsc --output $OUT $IN"
    ixt: \json.ls
    oxt: \json
  site_asset:
    pat: "#{Dirname.SITE}/asset/tract/*"
    cmd: "cp --target-directory $OUT $IN"
    ixt: \png
  site_pug:
    pat: "#{Dirname.SITE}/*"
    cmd: "#BIN/pug3 -O \"{version:'#{process.env.npm_package_version}'}\" --out $OUT $IN"
    ixt: \pug
    oxt: \html
  site_pug_include:
    pat: "#{Dirname.SITE}/include/*"
    ixt: '{pug,scss}'
    tid: \site_pug # task id to run
  site_pug_lib:
    pat: "#{Dirname.SITE}/lib/*"
    ixt: '{js,pug,scss}'
    tid: \site_pug # task id to run
  task_ls:
    pat: "#{Dirname.TASK}/**/*"
    cmd: "#BIN/lsc --output $OUT $IN"
    ixt: \ls
    oxt: \js
  task_static:
    pat: "#{Dirname.TASK}/**/*"
    cmd: "cp --target-directory $OUT $IN"
    ixt: '{json,lson}'

module.exports = me = (new Emitter!) with
  all: ->
    for tid of tasks then compile-batch tid
    me.emit \built

  start: ->
    log Chalk.green 'start build'
    try
      pushd Dir.SRC
      for tid of tasks then start-watching tid
    finally popd!

  stop: ->
    log Chalk.red 'stop build'
    for , t of tasks then t.watcher?close!

## helpers

function compile t, ipath
  return unless t.cmd or t.run
  Assert.equal pwd!, Dir.BUILD
  mkdir \-p odir = Path.dirname opath = get-opath t, ipath
  if t.cmd
    cmd = t.cmd.replace(\$IN ipath).replace(\$OUT odir).replace(\$OPATH opath)
    log Chalk.blue cmd
    Cp.execSync cmd, {stdio: \pipe} # hide stdout/err to avoid duplicating error messages
    G.ok opath
  if t.run
    mod = "../#{t.dir}/#{t.run}"
    log Chalk.blue 'run module:' mod
    delete require.cache[require.resolve(mod)]; # invalidate cache
    (require mod)(ipath, opath)

function compile-batch tid
  t = tasks[tid]
  w = t.watcher.getWatched!
  files = [f for path, names of w for name in names
    when test \-f f = Path.resolve Dir.SRC, path, name]
  info = "#{files.length} #tid files"
  G.say "compiling #info..."
  for f in files then compile t, f
  G.ok "...done #info!"

function get-opath t, ipath
  rx = new RegExp("^#{Dir.SRC}/")
  ipath.replace(rx, '').replace t.ixt, t.oxt

function start-watching tid
  Assert.equal pwd!, Dir.SRC
  t = tasks[tid]
  pat = t.pat + ".#{t.ixt}"
  log "start watching #tid: #pat"
  w = t.watcher = Choki.watch pat, {cwd:Dir.SRC, ignoreInitial:true}
  w.on \all (act, path) ->
    ipath = Path.join(Dir.SRC, path)
    log Chalk.yellow(\build), act, tid, ipath
    try
      if t?tid then compile-batch t.tid
      else if act in [\add \change] then opath = compile t, ipath
      else return
    catch e then return G.err e
    me.emit \built
