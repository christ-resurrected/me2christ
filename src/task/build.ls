_       = require \lodash
Assert  = require \assert
Chalk   = require \chalk
Glob    = require \glob .globSync
Emitter = require \events .EventEmitter
Fs      = require \fs
Match   = require \minimatch
P       = require \child_process
Path    = require \path
Sh      = require \shelljs
Dirname = require \./constants .dirname
Dir     = require \./constants .dir
G       = require \./growl

const BIN = "#{Dir.BUILD}/node_modules/.bin"

tasks =
  json_ls:
    dir: \.
    cmd: "#BIN/lsc --output $OUT $IN"
    ixt: \json.ls
    oxt: \json
  site_asset:
    dir: "#{Dirname.SITE}/asset/tract"
    cmd: "cp --target-directory $OUT $IN"
    ixt: \png
  site_pug:
    dir: Dirname.SITE
    cmd: "#BIN/pug3 -O \"{version:'#{process.env.npm_package_version}'}\" --out $OUT $IN"
    ixt: \pug
    oxt: \html
  # site_pug_embed:
  #   dir: Dirname.SITE
  #   ixt: '{js,pug,scss}'
  #   pat: \*/*
  #   tid: \site_pug # task id to run
  site_pug_include:
    dir: "#{Dirname.SITE}/include"
    ixt: '{pug,scss}'
    tid: \site_pug # task id to run
  site_pug_lib:
    dir: "#{Dirname.SITE}/lib"
    ixt: '{js,pug,scss}'
    tid: \site_pug # task id to run
  task_lint:
    dir: "#{Dirname.TASK}/lint"
    cmd: "cp --target-directory $OUT $IN"
    ixt: '{js,json,lson}'
  task_ls:
    dir: Dirname.TASK
    cmd: "#BIN/lsc --output $OUT $IN"
    ixt: \ls
    oxt: \js
  task_ls_yarn:
    dir: "#{Dirname.TASK}/yarn"
    cmd: "#BIN/lsc --output $OUT $IN"
    ixt: \ls
    oxt: \js

module.exports = me = (new Emitter!) with
  all: ->
    for tid of tasks then compile-batch-b tid
    me.emit \built

  start: ->
    log Chalk.green 'start build'
    try
      Sh.pushd Dir.SRC
      for tid of tasks then start-watching tid
    finally Sh.popd!

  stop: ->
    log Chalk.red 'stop build'
    for , t of tasks then t.watcher?close!

## helpers

function compile t, ipath
  return unless t.cmd or t.run
  Assert.equal Sh.pwd!, Dir.BUILD
  Sh.mkdir \-p odir = Path.dirname opath = get-opath t, ipath
  cmd = t.cmd.replace(\$IN ipath).replace(\$OUT odir).replace(\$OPATH opath)
  log Chalk.blue cmd
  P.execSync cmd, {stdio: \pipe} # hide stdout/err to avoid duplicating error messages

function compile-batch-b tid
  t = tasks[tid]
  files = Glob t.glob
  info = "#{files.length} #tid files"
  G.say "compiling #info..."
  for f in files then compile t, f
  G.ok "...done #info!"

function get-opath t, ipath
  ipath.replace t.ixt, t.oxt if t.oxt
  Path.relative Dir.SRC, ipath

function start-watching tid
  Assert.equal pwd!, Dir.SRC
  dir = Path.resolve Dir.SRC, (t = tasks[tid]).dir
  t.glob = Path.resolve dir, pat = "*.#{t.ixt}"
  log "start watching #tid: #pat in #dir"
  watch-once!

  function watch-once
    w = t.watcher = Fs.watch dir, {recursive:false}, (e, path) ->
      return unless Match path, pat
      w.close!
      setTimeout process, 50ms # wait for events to settle

      function process
        if t?tid then compile-batch-b t.tid
        else if Fs.existsSync ipath = Path.resolve dir, path then compile t, ipath
        setTimeout watch-once, 10ms
        me.emit \built
