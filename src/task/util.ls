Fs = require \fs

module.exports =
  clean-dir: ->
    Fs.rmSync it, {force:true, recursive:true}
    Fs.mkdirSync it
