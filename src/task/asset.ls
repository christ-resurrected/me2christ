Chalk   = require \chalk
Fs      = require \fs
Http    = require \https
P       = require \child_process
Path    = require \path
Sh      = require \shelljs
Dir     = require \./constants .dir
Dirname = require \./constants .dirname

module.exports =
  download-emoji-svgs: ->
    const NOTO = \https://raw.githubusercontent.com/googlefonts/noto-emoji/refs/heads/main/svg/emoji_
    const EMOJITWO = \https://raw.githubusercontent.com/EmojiTwo/emojitwo/refs/heads/master/svg/
    const EMOJI =
      dove: EMOJITWO + \1f54a.svg
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

  convert-tract-pdfs-to-pngs: -> # dependencies: imagemagick and optipng
    try
      Sh.pushd process.env.M2C_TRACT_PDF_PATH
      for f in Fs.readdirSync \. when f.endsWith \.pdf then
        Sh.rm \-f \/tmp/*.png # prepare
        basename = f.replace \.pdf ''
        log Chalk.blue convert = "convert -density 144 #basename.pdf /tmp/#basename-%02d.png"
        P.execSync convert # convert pdf to pngs, 1 per page
        P.execSync 'optipng /tmp/*.png' # reduce file sizes for productionn
        Sh.mv '/tmp/*.png' "#{Dir.SRC_SITE_ASSET}/tract/"
    finally Sh.popd!
