Chalk   = require \chalk
Cp      = require \child_process
Emitter = require \events .EventEmitter
Dirname = require \./constants .dirname
Dir     = require \./constants .dir
Fs      = require \fs
Sh      = require \shelljs

module.exports =
  tract: -> # dependencies: imagemagick and optipng
    try
      pushd process.env.M2C_TRACT_PDF_PATH
      for f in Fs.readdirSync \. when f.endsWith \.pdf then
        Sh.rm \-f \/tmp/*.png # prepare
        basename = f.replace \.pdf ''
        log Chalk.blue convert = "convert -density 144 #basename.pdf /tmp/#basename-%02d.png"
        Cp.execSync convert # convert pdf to pngs, 1 per page
        Cp.execSync "optipng /tmp/*.png" # reduce file sizes for productionn
        Sh.mv "/tmp/*.png", "#{Dir.SRC}/#{Dirname.SITE}/asset/tract/"
    finally popd!
