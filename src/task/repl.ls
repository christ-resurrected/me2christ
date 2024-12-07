global.log = -> console.log it; it

Chalk   = require \chalk
P       = require \child_process
Rl      = require \readline
Asset   = require \./asset
Build   = require \./build
Consts  = require \./constants
Dir     = require \./constants .dir
Dirname = require \./constants .dirname
Lint    = require \./lint
LiveRl  = require \./livereload
Rsource = require \./resource
Site    = require \./site

const CHALKS = [Chalk.stripColor, Chalk.yellow, Chalk.red]
const COMMANDS =
  * cmd:'h ' level:0 desc:'help (show commands)'  fn:show-help
  * cmd:'ae' level:1 desc:'asset.download-emoji'  fn:Asset.download-emoji-svgs
  * cmd:'at' level:1 desc:'asset.convert-tracts'  fn:Asset.convert-tract-pdfs-to-pngs
  * cmd:'b ' level:0 desc:'build all'             fn:Build.all
  * cmd:'l ' level:0 desc:'lint all'              fn:Lint.all
  * cmd:'r1' level:1 desc:'resource.download-kjv' fn:Rsource.download-kjv-json
  * cmd:'r2' level:1 desc:'resource.gen-verses'   fn:Rsource.generate-verses-json
  * cmd:'q ' level:0 desc:'QUIT'                  fn:process.exit

function show-help then for c in COMMANDS then log c.display
for c in COMMANDS then c.display = "#{Chalk.bold CHALKS[c.level] c.cmd} #{c.desc}"

rl = Rl.createInterface input:process.stdin, output:process.stdout
  ..setPrompt "#{Consts.APPNAME} >"
  ..on \line (cmd) ->
    rl.pause!
    for c in COMMANDS when cmd is c.cmd.trim! then try c.fn! catch e then log e
    rl.resume!
    rl.prompt!

Build.on \built -> rl.prompt!; LiveRl.notify!
Build.on \error -> rl.prompt!
Build.on \restart -> P.execSync "touch #{Dir.BUILD}/.restart-node"
Build.start!

Lint.on \done -> rl.prompt!
Lint.start!

<- Site.start!
LiveRl.start!
show-help!
rl.prompt!
