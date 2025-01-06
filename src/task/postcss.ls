Postcss = require \postcss
Import  = require \postcss-import-sync2
Mixins  = require \postcss-mixins
Nested  = require \postcss-nested
Sugarss = require \sugarss
Dir     = require \./constants .dir

module.exports =
  process: ->
    imp = Import path: "#{Dir.SRC_SITE}/lib"
    plugins = [Mixins, Nested]
    css = Postcss(plugins).use(imp).process(it, {from:undefined, parser:Sugarss}).css
    log css
    css
