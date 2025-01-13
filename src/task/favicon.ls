A   = require \assert
Fi  = require \favicons
Fs  = require \fs
P   = require \path
Pug = require \pug
Dir = require \./constants .dir

const FAVICON_PATH = P.resolve Dir.SRC_SITE_ASSET, \favicon

module.exports = ->>
  svg = Pug.renderFile P.resolve Dir.SRC_TASK, \favicon.pug
  Fs.writeFileSync spath = "#FAVICON_PATH/favicon.svg", svg
  c = Fi.config.defaults
  c.output.files = false
  c.output.html = false
  c.icons.favicons = [{name: 'favicon.ico', sizes: [
    {width: 16, height: 16},
    {width: 32, height: 32},
  ]}]
  res = await Fi.favicons spath, c
  # default
  write-image \favicon.ico
  # google, chrome
  write-image \android-chrome-48x48.png
  write-image \android-chrome-192x192.png
  # iPad, iPhone
  write-image \apple-touch-icon-167x167.png
  write-image \apple-touch-icon-180x180.png

  function write-image fname
    try
      A (img = res.images.filter -> it.name is fname).length is 1
      Fs.writeFileSync "#FAVICON_PATH/#fname", img.0.contents
    catch err then log err
