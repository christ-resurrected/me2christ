Fs  = require \fs
P   = require \path
Dir = require \../constants .dir

module.exports = (css) ->
  const ENCODING = \base64 # cssnano seems to compress base64 better than utf8
  const RE = /inline-svg\((.+?)\)/g

  for m in [...css.matchAll RE]
    svg = Fs.readFileSync P.resolve Dir.SRC_SITE, \resource, "#{m.1}.svg"
    svg64 = svg.toString ENCODING
    css = css.replace m.0, "url('data:image/svg+xml;#ENCODING,#svg64')"
  css
