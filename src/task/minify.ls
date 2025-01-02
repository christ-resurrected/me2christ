# see https://jeffkreeftmeijer.com/nodejs-purge-minify-css/
Cssnano = require \cssnano
Postcss = require \postcss

module.exports = me =
  enabled: true
  toggle-enabled: -> me.enabled = not me.enabled

  css: ->>
    return it unless me.enabled

    function process mat then Postcss([Cssnano!]).process(mat[1]).then(-> mat[0].replace mat[1], it.css)
    const RX = new RegExp '<style>(.+?)<\/style>' \gs  # livescript renders /regex/gs as /regex/g.s

    promises = [...it.matchAll RX].map process
    replacements = await Promise.all promises
    it.replace RX, -> replacements.shift!

  html-comments: function
    return it unless me.enabled
    it.replace /<!--(.*?)-->/g ''
