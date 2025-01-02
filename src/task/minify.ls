# see https://jeffkreeftmeijer.com/nodejs-purge-minify-css/
Cssnano = require \cssnano
Postcss = require \postcss

module.exports =
  css: ->>
    const RX = new RegExp '<style>(.+?)<\/style>' \gs  # livescript renders /regex/gs as /regex/g.s
    promises = [...it.matchAll RX].map process
    replacements = await Promise.all promises
    it.replace RX, -> replacements.shift!

  html-comments: -> it.replace /<!--(.*?)-->/g ''

function process mat then Postcss([Cssnano!]).process(mat[1]).then(-> mat[0].replace mat[1], it.css)
