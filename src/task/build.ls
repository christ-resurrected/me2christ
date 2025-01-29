Emitter = require \events .EventEmitter
Fs      = require \fs
C       = require \./constants
Dirname = require \./constants .dirname
Dir     = require \./constants .dir
Flag    = require \./flag
T       = require \./task

const TASKS = T.init const _TASKS =
  json_ls:
    cmd: "yarn --silent lsc --output $ODIR $IN"
    dir: \.
    ord: 1 # run first to avoid "Unexpected end of JSON input" error
    pat: \*.json.ls
  site_asset:
    cmd: "cp --target-directory $ODIR $IN"
    dir: "#{Dirname.SITE}/asset"
    ord: 2
    pat: '*/*.{png,svg}'
  site_asset_favicon:
    cmd: "cp --target-directory #{Dir.BUILD_SITE} $IN"
    dir: "#{Dirname.SITE}/asset/favicon"
    ord: 2
    pat: \*.ico
  site_js_sss:
    dir: Dirname.SITE
    pat: '**/*.{js,sss}'
    pid: \site_pug # parent task id to run
  site_pug:
    dir: Dirname.SITE
    fun: require \./task-pug .render
    ord: 2
    oxt: \html
    pat: '!(*.*).pug'
  site_pug_child:
    dir: Dirname.SITE
    pat: '{*.*,*/*}.pug'
    pid: \site_pug
  site_resource_favicon:
    dir: "#{Dirname.SITE}/resource/favicon"
    fun: require \./favicon unless Flag.prod # favicons package not available in production
    pat: \*.pug
  site_resource_pug:
    dir: "#{Dirname.SITE}/resource"
    fun: require \./task-pug .render
    out: Dir.SRC
    oxt: \svg
    pat: \*.pug
  site_resource_svg:
    dir: "#{Dirname.SITE}/resource"
    pat: '**/*.svg'
    pid: \site_pug
  task_ls:
    cmd: "yarn --silent lsc --output $ODIR $IN"
    dir: Dirname.TASK
    ord: 2
    pat: \**/*.ls
    rsn: true # restart node

module.exports = me = (new Emitter!) with
  all: ->>
    Fs.rmSync Dir.BUILD_SITE, {force:true, recursive:true}
    Fs.rmSync Dir.BUILD_TASK, {force:true, recursive:true}
    Fs.mkdirSync Dir.BUILD_SITE
    try
      for ord in [1,2] then await T.run-tasks {[tid, t] for tid, t of TASKS when t.ord is ord}
      me.emit \restart
    catch err then log err; me.emit \error
  start: -> for _, t of TASKS then T.start-watching \build, me, t
