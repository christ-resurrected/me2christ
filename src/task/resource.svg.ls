Fs  = require \fs
P   = require \path
Pug = require \pug
Dir = require \./constants .dir

module.exports =
  compile: ->
    svg = Pug.renderFile it
    Fs.writeFileSync (out = it.replace /\.pug$/ ''), svg
