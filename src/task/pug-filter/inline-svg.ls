Fs   = require \fs
Min  = require \mini-svg-data-uri
P    = require \path
Svgo = require \svgo .optimize
Dir  = require \../constants .DIR

# Postcss inline-svg plugin is async only so yields error.
#
# Therefore this sync filter is required.
#
module.exports = (css) ->
  for m in [...css.matchAll /inline-svg\((.+?)\)/g]
    svg = Fs.readFileSync P.resolve Dir.SRC_SITE_RESOURCE, "#{m.1}.svg"
    svg = svg.toString \utf8
    svg = (Svgo svg).data
    # svg = Min svg # this is better than base64 or encodeURIComponent
    svg = encodeURIComponent svg
    css = css.replace m.0, "url('data:image/svg+xml;utf8,#svg')"
  css
