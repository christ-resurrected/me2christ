Postcss = require \postcss
Calc    = require \postcss-calc
Each    = require \postcss-each
Import  = require \postcss-import-sync2
Mixins  = require \postcss-mixins
Nested  = require \postcss-nested
PresEnv = require \postcss-preset-env
Sugarss = require \sugarss
Dir     = require \../constants .dir
Flag    = require \../flag

const IMPORT = Import path: "#{Dir.SRC_SITE}/lib/postcss-import"
const PLUGINS_DEV = [Mixins, Calc, Each, Nested]
const PLUGINS_PROD = PLUGINS_DEV.concat [PresEnv]
const PROCESS_OPTS = from:undefined, parser:Sugarss

module.exports = ->
  plugins = if Flag.prod then PLUGINS_PROD else PLUGINS_DEV
  Postcss(plugins).use(IMPORT).process(it, PROCESS_OPTS).css
