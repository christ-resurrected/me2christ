Fs  = require \fs
Cp  = require \child_process
Dir = require \./constants .DIR
U   = require \./util

# dependency: imagemagick
module.exports =
  ministry: -> # dependency: oxipng, to compress for production
    TMPDIR = \/tmp/tract
    U.clean-dir "#TMPDIR/raw"
    U.clean-dir "#TMPDIR/thumb"
    for f in Fs.readdirSync PDFDIR = process.env.M2C_TRACT_PDF_PATH when f.endsWith \.pdf
      ofile = f.replace \.pdf \-%02d
      Cp.execSync log "magick -density 144 #PDFDIR/#f -strip #TMPDIR/raw/#ofile.png"
      Cp.execSync log "magick -density 288 #PDFDIR/#f -sample 25% -strip #TMPDIR/thumb/#ofile.png"

    function deploy type
      const TDIR = "#TMPDIR/#type"
      const ODIR = "#{Dir.SRC_SITE_ASSET_TRACT_MINISTRY}/#type"
      U.clean-dir ODIR
      Cp.execSync "oxipng --opt 4 --strip all #TDIR/*.png"
      for f in Fs.readdirSync TDIR then Fs.copyFileSync "#TDIR/#f" "#ODIR/#f"

    deploy \raw
    deploy \thumb

  generate-deception-thumbnails: ->
    function get-dir then "#{Dir.SRC_SITE_ASSET_TRACT_DECEPTION}/#it"
    const PDFDIR = get-dir \raw # from MacOS photos -> file -> export -> export 1 photo -> jpeg: high, large
    const ODIR = get-dir \thumb
    for f in Fs.readdirSync PDFDIR then Cp.execSync log "magick -density 288 #PDFDIR/#f -sample 25% -strip #ODIR/#f"
