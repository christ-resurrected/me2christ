Emit = require \events .EventEmitter
Fs   = require \fs
Http = require \https
Dir  = require \./constants .dir
Path = require \path
Sh   = require \shelljs

module.exports = me = (new Emit!) with
  download: ->
    const NOTO = \https://raw.githubusercontent.com/googlefonts/noto-emoji/refs/heads/main/svg/emoji_
    const EMOJI =
      # faith_christ: NOTO + \u271d.svg
      fire: NOTO + \u1f525.svg
      megaphone: NOTO + \u1f4e2.svg
      seedling: NOTO + \u1f331.svg
      skull_bones: NOTO + \u2620.svg

    for key, url of EMOJI then download key, url

function download key, url then Http.get url, (res) ->
  return log "ERROR #{res.statusCode} #key #url" unless res.statusCode is 200
  data = ''
  res.on \data -> data += it
  res.on \end ->
    try
      Sh.mkdir \-p odir = Path.resolve Dir.SRC_SITE_ASSET, \emoji
      Fs.writeFileSync (opath = Path.resolve odir, "#key.svg"), data
      log "wrote #{data.length} bytes to #opath"
    catch err then log err
