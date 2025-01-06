Postcss = require \postcss
Import  = require \postcss-import-sync2
Mixins  = require \postcss-mixins
Dir     = require \./constants .dir

module.exports =
  process: ->
    imp = Import path: "#{Dir.SRC_SITE}/lib"
    plugins = [Mixins]
    css = Postcss(plugins).use(imp).process(it, {from:undefined}).css
    log css.length
    css
