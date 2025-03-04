E    = require \events
C    = require \./constants
Dir  = require \./constants .DIR
Flag = require \./flag
T    = require \./task
U    = require \./util

const TASKS = T.init const _TASKS =
  json_ls:
    cmd: "yarn --silent lsc --output $ODIR $IN"
    dir: Dir.SRC
    ord: 1 # run first to avoid "Unexpected end of JSON input" error
    pat: \*.json.ls
  site_asset:
    cmd: "cp --target-directory $ODIR $IN"
    dir: Dir.SRC_SITE_ASSET
    ord: 2
    pat: '**/*.{jpg,png,svg}'
  site_asset_favicon:
    cmd: "cp --target-directory #{Dir.BUILD_SITE} $IN"
    dir: Dir.SRC_SITE_ASSET_FAVICON
    ord: 2
    pat: \*.ico
  site_js_sss:
    dir: Dir.SRC_SITE
    pat: '**/*.{js,sss}'
    pid: \site_pug # parent task id to run
  site_pug:
    dir: Dir.SRC_SITE
    fun: require \./task-pug .render
    ord: 2
    oxt: \html
    pat: '!(*.*).pug'
  site_pug_child:
    dir: Dir.SRC_SITE
    pat: '{*.*,*/*}.pug'
    pid: \site_pug
  site_resource_favicon:
    dir: "#{Dir.SRC_SITE_RESOURCE}/favicon"
    fun: require \./favicon unless Flag.prod # favicons package not available in production
    pat: \*.pug
  site_resource_pug:
    dir: Dir.SRC_SITE_RESOURCE
    fun: require \./task-pug .render
    out: Dir.SRC
    oxt: \svg
    pat: \*.pug
  site_resource_svg:
    dir: Dir.SRC_SITE_RESOURCE
    pat: '**/*.svg'
    pid: \site_pug
  task_ls:
    cmd: "yarn --silent lsc --output $ODIR $IN"
    dir: Dir.SRC_TASK
    ord: 2
    pat: \**/*.ls
    rsn: true # restart node

module.exports = me = (new E.EventEmitter!) with
  all: ->>
    U.clean-dir Dir.BUILD_SITE
    U.clean-dir Dir.BUILD_TASK
    try
      for ord in [1,2] then await T.run-tasks {[tid, t] for tid, t of TASKS when t.ord is ord}
      me.emit \built-all
    catch err then log err; me.emit \error
  debug: -> for tid, t of TASKS then log tid, t
  watch: -> for _, t of TASKS then T.start-watching \build, me, t
