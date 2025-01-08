AutoPre = require \autoprefixer
Postcss = require \postcss
Import  = require \postcss-import-sync2
Mixins  = require \postcss-mixins
Nested  = require \postcss-nested
Sugarss = require \sugarss
Dir     = require \./constants .dir

const IMPORT = Import path: "#{Dir.SRC_SITE}/lib"
const OPTS = from:undefined, parser:Sugarss
const PLUGINS = [Mixins, Nested, AutoPre]

module.exports = ->
  res = Postcss(PLUGINS).use(IMPORT).process(it, OPTS)
  log res.css
  res.css
