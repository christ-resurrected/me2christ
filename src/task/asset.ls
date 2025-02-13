Fs      = require \fs
Http    = require \https
P       = require \child_process
Path    = require \path
Dir     = require \./constants .DIR

module.exports =
  download-emoji: ->
    const ODIR = Path.resolve Dir.SRC_SITE_RESOURCE, \emoji
    const NOTO = \https://raw.githubusercontent.com/googlefonts/noto-emoji/refs/heads/main/svg/emoji_
    const EMOJITWO = \https://raw.githubusercontent.com/EmojiTwo/emojitwo/refs/heads/master/svg/
    const EMOJI =
      cross: \https://upload.wikimedia.org/wikipedia/commons/8/87/Christian_cross.svg
      dove: EMOJITWO + \1f54a.svg
      excl_double: NOTO + \u203c.svg
      fire: NOTO + \u1f525.svg
      gavel: \https://www.svgrepo.com/download/60798/gavel.svg
      megaphone: NOTO + \u1f4e2.svg
      scroll: NOTO + \u1f4dc.svg
      seedling: NOTO + \u1f331.svg
      skull_bones: NOTO + \u2620.svg
      warning: NOTO + \u26a0.svg
    for key, url of EMOJI then download-asset key, url, ODIR

  download-symbols: ->
    const ODIR = Path.resolve Dir.SRC_SITE_RESOURCE, \symbol
    const SYMBOLS =
      link_external: \https://www.iconbolt.com/iconsets/remix-icon-fill/external-link.svg
    for key, url of SYMBOLS then download-asset key, url, ODIR

  convert-tract-pdfs-to-pngs: -> # dependencies: imagemagick and optipng
    Fs.rmSync tdir = \/tmp/tract {force:true, recursive:true}; Fs.mkdirSync tdir
    for f in Fs.readdirSync idir = process.env.M2C_TRACT_PDF_PATH when f.endsWith \.pdf
      ofile = f.replace \.pdf \-%02d
      P.execSync log "magick -density 144 #idir/#f -strip #tdir/#ofile.png"
      P.execSync log "magick -density 288 #idir/#f -sample 25% -strip #tdir/#{ofile}-thumbnail.png"
    P.execSync "oxipng --opt 4 --strip all #tdir/*.png" # reduce file sizes for production
    for png in Fs.readdirSync tdir then Fs.copyFileSync "#tdir/#png" "#{Dir.SRC_SITE_ASSET}/tract/#png"

function download-asset key, url, odir then Http.get url, (res) ->
  return log "ERROR #{res.statusCode} #key #url" unless res.statusCode is 200
  data = ''
  res.on \data -> data += it
  res.on \end ->
    try
      if !Fs.existsSync odir then Fs.mkdirSync odir
      Fs.writeFileSync (opath = Path.resolve odir, "#key#{Path.extname url}"), data
      log "wrote #{data.length} bytes to #opath"
    catch err then log err
