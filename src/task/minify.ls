# see https://jeffkreeftmeijer.com/nodejs-purge-minify-css/
Chalk   = require \chalk
Cssnano = require \cssnano
Postcss = require \postcss
Uglijs  = require \uglify-js

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
    log-stats \css, it, out
    out

  html-comments: ->
    return it unless me.enabled
    it.replace /<!--(.*?)-->/g ''

  js: ->>
    return it unless me.enabled
    # log it.length
    function process mat then new Promise (resolve, reject) ->
      res = Uglijs.minify mat[1]
      if res.error then reject res.error else resolve res.code
    const RX = new RegExp '<script>(.+?)<\/script>' \gs  # livescript renders /regex/gs as /regex/g.s
    promises = [...it.matchAll RX].map process
    replacements = await Promise.all promises
    out = it.replace RX, -> replacements.shift!
    log-stats \js, it, out
    out

function log-stats filetype, input, output
  delta = input.length - output.length
  percent = (100 * delta / input.length).toFixed 2
  log Chalk.yellow "Reduced #filetype by #{delta.toLocaleString!} bytes (#percent%)"
