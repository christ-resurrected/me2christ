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
  c.icons.favicons = [{name: 'favicon.ico', sizes: [{width: 32, height: 32}]}]
  res = await Fi.favicons spath, c
  write-image res.images, \favicon.ico
  write-image res.images, \apple-touch-icon-180x180.png

  function write-image images, fname
    try
      A (img = images.filter -> it.name is fname).length is 1
      Fs.writeFileSync "#FAVICON_PATH/#fname", img.0.contents
    catch err then log err
