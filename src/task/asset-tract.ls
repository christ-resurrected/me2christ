Chalk   = require \chalk
Cp      = require \child_process
Dirname = require \./constants .dirname
Dir     = require \./constants .dir
Fs      = require \fs
Sh      = require \shelljs

module.exports =
  convert: -> # dependencies: imagemagick and optipng
    try
      pushd process.env.M2C_TRACT_PDF_PATH
      for f in Fs.readdirSync \. when f.endsWith \.pdf then
        Sh.rm \-f \/tmp/*.png # prepare
        basename = f.replace \.pdf ''
        log Chalk.blue convert = "convert -density 144 #basename.pdf /tmp/#basename-%02d.png"
        Cp.execSync convert # convert pdf to pngs, 1 per page
        Cp.execSync 'optipng /tmp/*.png' # reduce file sizes for productionn
        Sh.mv '/tmp/*.png' "#{Dir.SRC_SITE_ASSET}/tract/"
    finally popd!
