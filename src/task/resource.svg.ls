Fs  = require \fs
P   = require \path
Pug = require \pug
Dir = require \./constants .dir

module.exports =
  compile: ->
    svg = Pug.renderFile it, filters: postcss: require \./pug-filter/postcss
    Fs.writeFileSync (out = it.replace /\.pug$/ ''), svg
