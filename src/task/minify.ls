# see https://jeffkreeftmeijer.com/nodejs-purge-minify-css/
Chalk   = require \chalk
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
    out = it.replace RX, -> replacements.shift!
    delta = it.length - out.length
    percent = (100 * delta / it.length).toFixed 2
    log Chalk.yellow "Reduced css by #{delta.toLocaleString!} bytes (#percent%)"
    out

  html-comments: ->
    return it unless me.enabled
    it.replace /<!--(.*?)-->/g ''
