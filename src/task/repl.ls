global.log = console.log

Chalk   = require \chalk
Sh      = require \shelljs
Rl      = require \readline
Asset   = require \./asset
Build   = require \./build
Consts  = require \./constants
Dir     = require \./constants .dir
Dirname = require \./constants .dirname
Emoji   = require \./emoji
Lint    = require \./lint
LiveRl  = require \./livereload
Site    = require \./site

const CHALKS = [Chalk.stripColor, Chalk.yellow, Chalk.red]
const COMMANDS =
  * cmd:'h ' level:0 desc:'help (show commands)' fn:show-help
  * cmd:'a ' level:0 desc:'asset.tract'          fn:Asset.tract
  * cmd:'b ' level:0 desc:'build all'            fn:Build.all
  * cmd:'e ' level:0 desc:'emoji.download'       fn:Emoji.download
  * cmd:'l ' level:0 desc:'lint all'             fn:Lint.all
  * cmd:'q ' level:0 desc:'QUIT'                 fn:process.exit

Sh.config.fatal  = true # shelljs doesn't raise exceptions, so set this process to die on error
#config.silent = true # otherwise too much noise

Sh.cd Dir.BUILD # for safety, set working directory to build

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
Build.on \restart -> Sh.touch \.restart-node
Build.start!

Lint.on \done -> rl.prompt!
Lint.start!

<- Site.start!
LiveRl.start!
show-help!
rl.prompt!
