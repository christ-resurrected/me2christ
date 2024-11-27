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

tasks =
  json_ls:
    cmd: "lsc --output $OUT $IN"
    dir: \.
    ixt: \json.ls
    oxt: \json
  site_asset:
    cmd: "cp --target-directory $OUT $IN"
    dir: "#{Dirname.SITE}/asset/tract"
    ixt: \png
  site_pug:
    cmd: "pug3 -O \"{version:'#{process.env.npm_package_version}'}\" --out $OUT $IN"
    dir: Dirname.SITE
    ixt: \pug
    oxt: \html
  site_pug_embed:
    dir: Dirname.SITE
    ixt: '{js,pug,scss}'
    pat: '*/' # subdir 1-level deep
    tid: \site_pug # task id to run
  task_lint:
    cmd: "cp --target-directory $OUT $IN"
    dir: "#{Dirname.TASK}/lint"
    ixt: '{js,json,lson}'
  task_ls:
    cmd: "lsc --output $OUT $IN"
    dir: Dirname.TASK
    ixt: \ls
    oxt: \js
    pat: '**/'

for , t of tasks then
  t.pat = (t.pat || '') + "*.#{t.ixt}"
  t.srcdir = Path.resolve Dir.SRC, t.dir
  t.glob = Path.resolve t.srcdir, t.pat

module.exports = me = (new Emitter!) with
  all: ->
    Sh.rm \-rf Dir.build.SITE
    for tid of tasks then compile-batch tid
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
  Assert.equal Sh.pwd!, Dir.BUILD
  Sh.mkdir \-p odir = Path.dirname opath = get-opath t, ipath
  log Chalk.blue cmd = t.cmd.replace(\$IN ipath).replace(\$OUT odir).replace(\$OPATH opath)
  P.execSync "yarn #cmd", {stdio: \pipe} # hide stdout/err to avoid duplicating error messages

function compile-batch tid
  files = Glob (t = tasks[tid]).glob
  info = "#{files.length} #tid files"
  G.say "compiling #info..."
  for f in files then compile t, f
  G.ok "...done #info!"

function get-opath t, ipath
  ipath.replace t.ixt, t.oxt if t.oxt
  Path.relative Dir.SRC, ipath

function start-watching tid
  Assert.equal pwd!, Dir.SRC
  t = tasks[tid]
  log "start watching #tid: #{t.pat} in #{t.srcdir}"
  watch-once!
  function watch-once
    w = t.watcher = Fs.watch t.srcdir, {recursive:true}, (e, path) ->
      return unless Match path, t.pat
      w.close!
      setTimeout process, 50ms # wait for events to settle
      function process
        if t?tid then compile-batch t.tid
        else if Fs.existsSync ipath = Path.resolve t.srcdir, path then compile t, ipath
        setTimeout watch-once, 10ms
        me.emit \built
