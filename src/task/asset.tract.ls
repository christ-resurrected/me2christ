Fs   = require \fs
P    = require \child_process
Path = require \path
Dir  = require \./constants .DIR

module.exports =
  convert-tract-pdfs-to-pngs: -> # dependencies: imagemagick and optipng
    Fs.rmSync tdir = \/tmp/tract {force:true, recursive:true}; Fs.mkdirSync tdir
    for f in Fs.readdirSync idir = process.env.M2C_TRACT_PDF_PATH when f.endsWith \.pdf
      ofile = f.replace \.pdf \-%02d
      P.execSync log "magick -density 144 #idir/#f -strip #tdir/#ofile.png"
      P.execSync log "magick -density 288 #idir/#f -sample 25% -strip #tdir/#{ofile}-thumbnail.png"
    P.execSync "oxipng --opt 4 --strip all #tdir/*.png" # reduce file sizes for production
    for png in Fs.readdirSync tdir then Fs.copyFileSync "#tdir/#png" "#{Dir.SRC_SITE_ASSET}/tract/#png"
