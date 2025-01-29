A   = require \assert
Fi  = require \favicons
Fs  = require \fs
P   = require \path
Pug = require \pug
Dir = require \./constants .dir

const FAVICON_PATH = P.resolve Dir.SRC_SITE_ASSET, \favicon

module.exports = ->>
  ipath = P.resolve Dir.SRC_TASK, \favicon.pug
  svg = Pug.renderFile ipath, filters: postcss: require \./pug-filter/postcss
  Fs.writeFileSync spath = "#FAVICON_PATH/favicon.svg", svg
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
      Fs.writeFileSync "#FAVICON_PATH/#fname", img.0.contents
    catch err then log err
