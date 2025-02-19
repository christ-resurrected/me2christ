Fs   = require \fs
Http = require \https
P    = require \path
Dir  = require \./constants .DIR

module.exports =
  download-emoji: ->
    const ODIR = P.resolve Dir.SRC_SITE_RESOURCE, \emoji
    const NOTO = \https://raw.githubusercontent.com/googlefonts/noto-emoji/refs/heads/main/svg/emoji_
    const EMOJITWO = \https://raw.githubusercontent.com/EmojiTwo/emojitwo/refs/heads/master/svg/
    const SVGREPO = \https://www.svgrepo.com/download/
    const EMOJI =
      cross: \https://upload.wikimedia.org/wikipedia/commons/8/87/Christian_cross.svg
      dove: EMOJITWO + \1f54a.svg
      excl_double: NOTO + \u203c.svg
      fire: NOTO + \u1f525.svg
      gavel: SVGREPO + \60798/gavel.svg
      megaphone: NOTO + \u1f4e2.svg
      poison: SVGREPO + \444563/poison.svg
      scroll: NOTO + \u1f4dc.svg
      seedling: NOTO + \u1f331.svg
      send: SVGREPO + \288357/send.svg
      skull_bones: NOTO + \u2620.svg
      warning: NOTO + \u26a0.svg
    for key, url of EMOJI then download-asset key, url, ODIR

  download-symbols: ->
    const ODIR = P.resolve Dir.SRC_SITE_RESOURCE, \symbol
    const SYMBOLS =
      link_external: \https://www.iconbolt.com/iconsets/remix-icon-fill/external-link.svg
    for key, url of SYMBOLS then download-asset key, url, ODIR

function download-asset key, url, odir then Http.get url, (res) ->
  return log "ERROR #{res.statusCode} #key #url" unless res.statusCode is 200
  data = ''
  res.on \data -> data += it
  res.on \end ->
    try
      if !Fs.existsSync odir then Fs.mkdirSync odir
      Fs.writeFileSync (opath = P.resolve odir, "#key#{P.extname url}"), data
      log "wrote #{data.length} bytes to #opath"
    catch err then log err
