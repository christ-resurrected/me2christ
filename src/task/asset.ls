Fs      = require \fs
Http    = require \https
P       = require \child_process
Path    = require \path
Dir     = require \./constants .dir
Dirname = require \./constants .dirname

module.exports =
  download-emoji: ->
    const ODIR = Path.resolve Dir.SRC_SITE_ASSET, \emoji
    const NOTO = \https://raw.githubusercontent.com/googlefonts/noto-emoji/refs/heads/main/svg/emoji_
    const EMOJITWO = \https://raw.githubusercontent.com/EmojiTwo/emojitwo/refs/heads/master/svg/
    const EMOJI =
      checkmark_box: NOTO + \u2705.svg
      cross: \https://upload.wikimedia.org/wikipedia/commons/8/87/Christian_cross.svg
      crossmark: NOTO + \u274c.svg
      dove: EMOJITWO + \1f54a.svg
      fire: NOTO + \u1f525.svg
      megaphone: NOTO + \u1f4e2.svg
      seedling: NOTO + \u1f331.svg
      skull_bones: NOTO + \u2620.svg
    for key, url of EMOJI then download-svg key, url, ODIR

  download-symbols: ->
    const ODIR = Path.resolve Dir.SRC_SITE_ASSET, \symbol
    # const SYMBOLS =
    #   check: \https://raw.githubusercontent.com/FortAwesome/Font-Awesome/refs/heads/6.x/svgs/solid/check.svg
    # for key, url of SYMBOLS then download-svg key, url, ODIR

  convert-tract-pdfs-to-pngs: -> # dependencies: imagemagick and optipng
    Fs.rmSync tdir = \/tmp/tract {force:true, recursive:true}; Fs.mkdirSync tdir
    for f in Fs.readdirSync idir = process.env.M2C_TRACT_PDF_PATH when f.endsWith \.pdf then
      P.execSync log "convert -density 144 #idir/#f #tdir/#{f.replace \.pdf \-%02d.png}"
    P.execSync "optipng -quiet #tdir/*.png" # reduce file sizes for productionn
    for png in Fs.readdirSync tdir then Fs.copyFileSync "#tdir/#png" "#{Dir.SRC_SITE_ASSET}/tract/#png"

function download-svg key, url, odir then Http.get url, (res) ->
  return log "ERROR #{res.statusCode} #key #url" unless res.statusCode is 200
  data = ''
  res.on \data -> data += it
  res.on \end ->
    try
      if !Fs.existsSync odir then Fs.mkdirSync odir
      Fs.writeFileSync (opath = Path.resolve odir, "#key.svg"), data
      log "wrote #{data.length} bytes to #opath"
    catch err then log err
