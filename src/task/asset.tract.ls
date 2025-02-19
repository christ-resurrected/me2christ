Fs  = require \fs
Cp  = require \child_process
Dir = require \./constants .DIR
U   = require \./util

# dependency: imagemagick
module.exports =
  convert-pdfs-to-pngs: -> # dependency: oxipng
    U.clean-dir tdir = \/tmp/tract
    for f in Fs.readdirSync idir = process.env.M2C_TRACT_PDF_PATH when f.endsWith \.pdf
      ofile = f.replace \.pdf \-%02d
      Cp.execSync log "magick -density 144 #idir/#f -strip #tdir/#ofile.png"
      Cp.execSync log "magick -density 288 #idir/#f -sample 25% -strip #tdir/#{ofile}-thumbnail.png"
    Cp.execSync "oxipng --opt 4 --strip all #tdir/*.png" # reduce file sizes for production
    for png in Fs.readdirSync tdir then Fs.copyFileSync "#tdir/#png" "#{Dir.SRC_SITE_ASSET_TRACT}/#png"
