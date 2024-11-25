global.log = console.log

Chalk  = require \chalk
_      = require \lodash
Rl     = require \readline
Shell  = require \shelljs/global
Asset  = require \./asset
Build  = require \./build
Consts = require \./constants
Dir    = require \./constants .dir
G      = require \./growl
Lint   = require \./lint
Site   = require \./site

const CHALKS = [Chalk.stripColor, Chalk.yellow, Chalk.red]
const COMMANDS =
  * cmd:'h ' level:0 desc:'help (show commands)' fn:show-help
  * cmd:'a ' level:0 desc:'asset.tract'          fn:Asset.tract
  * cmd:'b ' level:0 desc:'build all'            fn:Build.all
  * cmd:'l ' level:0 desc:'lint all'             fn:Lint.all
  * cmd:'q ' level:0 desc:'QUIT'                 fn:process.exit

config.fatal  = true # shelljs doesn't raise exceptions, so set this process to die on error
#config.silent = true # otherwise too much noise

cd Dir.BUILD # for safety, set working directory to build

for c in COMMANDS then c.display = "#{Chalk.bold CHALKS[c.level] c.cmd} #{c.desc}"

rl = Rl.createInterface input:process.stdin, output:process.stdout
  ..setPrompt "#{Consts.APPNAME} >"
  ..on \line (cmd) ->
    rl.pause!
    for c in COMMANDS when cmd is c.cmd.trim!
      try c.fn!
      catch e then log e
    rl.resume!
    rl.prompt!

Build.on \built ->
  rl.prompt!

# Lint.start!
Build.start!
Site.start!

_.delay show-help, 500ms
_.delay (-> rl.prompt!), 750ms

## helpers

function show-help
  for c in COMMANDS then log c.display
