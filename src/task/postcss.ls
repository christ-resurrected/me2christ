Postcss = require \postcss
Import  = require \postcss-import-sync2
Mixins  = require \postcss-mixins
Nested  = require \postcss-nested
Dir     = require \./constants .dir

module.exports =
  process: ->
    imp = Import path: "#{Dir.SRC_SITE}/lib"
    plugins = [Mixins, Nested]
    Postcss(plugins).use(imp).process(it, from:undefined).css
