Fs  = require \fs
P   = require \path
Dir = require \../constants .dir

module.exports = (css) ->
  const RE = /url\((.+?\.svg)\)/g
  for m in [...css.matchAll RE]
    svg = Fs.readFileSync P.resolve Dir.SRC_SITE, m.1
    # cssnano seems to compress base64 better than utf8
    svg64 = svg.toString \base64
    css = css.replace m.0, "url('data:image/svg+xml;base64,#svg64')"
  css
