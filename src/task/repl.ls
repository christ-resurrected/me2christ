global.log = (...args) -> console.log(if args.length is 1 then args.0 else args); args.0

Chalk   = require \chalk
P       = require \child_process
Rl      = require \readline
Asset   = require \./asset
Build   = require \./build
Consts  = require \./constants
Dir     = require \./constants .dir
Dirname = require \./constants .dirname
Lint    = require \./lint
LiveRld = require \./livereload if process.env.M2C_LIVE_RELOAD
Resrc   = require \./resource
Site    = require \./site

show-help = -> for c in COMMANDS then log "#{Chalk.bold CHALKS[c.level] c.cmd} #{c.desc}"

const CHALKS = [Chalk.stripColor, Chalk.yellow, Chalk.red]
const COMMANDS =
  * cmd:'h ' level:0 desc:'help (show commands)'  fn:show-help
  * cmd:'ae' level:1 desc:'asset.download-emoji'  fn:Asset.download-emoji
  * cmd:'as' level:1 desc:'asset.download-syms'   fn:Asset.download-symbols
  * cmd:'at' level:1 desc:'asset.convert-tracts'  fn:Asset.convert-tract-pdfs-to-pngs
  * cmd:'b ' level:0 desc:'build all'             fn:Build.all
  * cmd:'l ' level:0 desc:'lint all'              fn:Lint.all
  * cmd:'r ' level:0 desc:'live reload'           fn:LiveRld?notify
  * cmd:'r1' level:1 desc:'resource.download-kjv' fn:Resrc.download-kjv-json
  * cmd:'r2' level:1 desc:'resource.gen-verses'   fn:Resrc.generate-verses-json
  * cmd:'q ' level:0 desc:'QUIT'                  fn:process.exit


rl = Rl.createInterface input:process.stdin, output:process.stdout
  ..setPrompt "#{Consts.APPNAME} >"
  ..on \line (cmd) ->
    rl.pause!
    for c in COMMANDS when cmd is c.cmd.trim! then try c.fn! catch e then log e
    rl.resume!
    rl.prompt!

Build.on \built -> rl.prompt!; LiveRld?notify!
Build.on \error -> rl.prompt!
Build.on \restart -> P.execSync "touch #{Dir.BUILD}/.restart-node"
Build.start!

Lint.on \done -> rl.prompt!
Lint.start!

<- Site.start!
LiveRld.start!
show-help!
rl.prompt!
