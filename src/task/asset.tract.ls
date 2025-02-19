Fs  = require \fs
CP  = require \child_process
Dir = require \./constants .DIR

module.exports =
  convert-pdfs-to-pngs: -> # dependencies: imagemagick and oxipng
    Fs.rmSync tdir = \/tmp/tract {force:true, recursive:true}; Fs.mkdirSync tdir
    for f in Fs.readdirSync idir = process.env.M2C_TRACT_PDF_PATH when f.endsWith \.pdf
      ofile = f.replace \.pdf \-%02d
      CP.execSync log "magick -density 144 #idir/#f -strip #tdir/#ofile.png"
      CP.execSync log "magick -density 288 #idir/#f -sample 25% -strip #tdir/#{ofile}-thumbnail.png"
    CP.execSync "oxipng --opt 4 --strip all #tdir/*.png" # reduce file sizes for production
    for png in Fs.readdirSync tdir then Fs.copyFileSync "#tdir/#png" "#{Dir.SRC_SITE_ASSET}/tract/#png"
