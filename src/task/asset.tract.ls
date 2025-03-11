Fs  = require \fs
Cp  = require \child_process
Dir = require \./constants .DIR
U   = require \./util

# dependency: imagemagick
module.exports =
  deception: ->
    # Manually create the raw input jpg by this pipeline...
    #
    # 1. MacOS photos: file -> export -> export 1 photo -> HEIC: large
    #
    # 2. GIMP: open HEIC, add layers with red boxes, then export as jpg
    #
    # 3. run this function, to create the thumbnails
    #
    function get-dir then "#{Dir.SRC_SITE_ASSET_TRACT_DECEPTION}/#it"
    U.clean-dir ODIR = get-dir \thumb
    for f in Fs.readdirSync IDIR = get-dir \raw when f.endsWith \.jpg
      Cp.execSync log "magick -density 144 #IDIR/#f -sample 50% -strip #ODIR/#f"

  ministry: -> # dependency: oxipng, to compress for production
    function generate type, im-settings, im-operators = ''
      U.clean-dir ODIR = "#{Dir.SRC_SITE_ASSET_TRACT_MINISTRY}/#type"
      for f in Fs.readdirSync PDFDIR = process.env.M2C_TRACT_PDF_PATH when f.endsWith \.pdf
        ofile = f.replace(\.pdf \-%02d).replace \tract_ ''
        Cp.execSync log "magick #im-settings #PDFDIR/#f #im-operators -strip #ODIR/#ofile.png"
      Cp.execSync "oxipng --opt 4 --strip all #ODIR/*.png"
    generate \raw '-density 144'
    generate \thumb '-density 144' '-sample 50%'
