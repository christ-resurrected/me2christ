Postcss = require \postcss
Import  = require \postcss-import-sync2
Dir     = require \./constants .dir

module.exports =
  process: ->
    Postcss!use(Import path: "#{Dir.SRC_SITE}/lib").process(it).css
