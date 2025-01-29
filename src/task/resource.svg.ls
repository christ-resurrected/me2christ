Fs  = require \fs
P   = require \path
Pug = require \pug
Dir = require \./constants .dir

const OPTS =
  filters:
    postcss: require \./pug-filter/postcss

module.exports =
  compile: ->
    svg = Pug.renderFile it, OPTS
    Fs.writeFileSync (out = it.replace /\.pug$/ ''), svg
