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
const PLUGINS_DEV = [IMPORT, Mixins, Calc, Each, Nested]
const PLUGINS_PROD = PLUGINS_DEV.concat [PresEnv]

module.exports = -> Postcss(if Flag.prod then PLUGINS_PROD else PLUGINS_DEV).process(it, parser:Sugarss).css
