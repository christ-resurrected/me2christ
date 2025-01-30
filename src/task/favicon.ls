A   = require \assert
Fi  = require \favicons
Fs  = require \fs
P   = require \path
Pug = require \pug
Dir = require \./constants .DIR

module.exports = (ipath) ->>
  svg = Pug.renderFile ipath, filters: sss: require \./pug-filter/sss
  Fs.writeFileSync spath = "#{Dir.SRC_SITE_ASSET_FAVICON}/favicon.svg", svg
  c = Fi.config.defaults
  c.output.files = false
  c.output.html = false
  c.icons.favicons = [{name: \favicon.ico, sizes: [
    {width: 16, height: 16},
    {width: 32, height: 32},
  ]}]
  res = await Fi.favicons spath, c
  write-image \favicon.ico  # default
  write-images \android-chrome [48 192] # google search, chrome
  write-images \apple-touch-icon [167 180]  # ipad, iphone

  function write-images type, sizes then for s in sizes then write-image "#type-#{s}x#{s}.png"

  function write-image fname
    try
      A (img = res.images.filter -> it.name is fname).length is 1
      Fs.writeFileSync "#{Dir.SRC_SITE_ASSET_FAVICON}/#fname", img.0.contents
    catch err then log err
