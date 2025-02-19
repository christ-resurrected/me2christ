Fs  = require \fs
Cp  = require \child_process
Dir = require \./constants .DIR
U   = require \./util

# dependency: imagemagick
module.exports =
  deception: ->
    function get-dir then "#{Dir.SRC_SITE_ASSET_TRACT_DECEPTION}/#it"
    const ODIR = get-dir \thumb
    # raw input jpgs come from MacOS photos -> file -> export -> export 1 photo -> jpeg: high, large
    for f in Fs.readdirSync IDIR = get-dir \raw
      Cp.execSync log "magick -density 288 #IDIR/#f -sample 25% -strip #ODIR/#f"

  ministry: -> # dependency: oxipng, to compress for production
    function generate type, im-settings, im-operators = ''
      U.clean-dir TDIR = "/tmp/tract/#type"
      for f in Fs.readdirSync PDFDIR = process.env.M2C_TRACT_PDF_PATH when f.endsWith \.pdf
        ofile = f.replace \.pdf \-%02d
        Cp.execSync log "magick #im-settings #PDFDIR/#f #im-operators -strip #TDIR/#ofile.png"
      Cp.execSync "oxipng --opt 4 --strip all #TDIR/*.png"
      U.clean-dir ODIR = "#{Dir.SRC_SITE_ASSET_TRACT_MINISTRY}/#type"
      for tfile in Fs.readdirSync TDIR
        ofile = tfile.replace \tract_ ''
        Fs.copyFileSync "#TDIR/#tfile" "#ODIR/#ofile"

    generate \raw, '-density 144'
    generate \thumb, '-density 288', '-sample 25%'
