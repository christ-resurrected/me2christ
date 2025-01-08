Postcss = require \postcss
Import  = require \postcss-import-sync2
Mixins  = require \postcss-mixins
Nested  = require \postcss-nested
PresEnv = require \postcss-preset-env
Sugarss = require \sugarss
Dir     = require \./constants .dir

const IMPORT = Import path: "#{Dir.SRC_SITE}/lib"
const OPTS = from:undefined, parser:Sugarss
const PLUGINS = [Mixins, Nested, PresEnv]

module.exports = -> Postcss(PLUGINS).use(IMPORT).process(it, OPTS).css
