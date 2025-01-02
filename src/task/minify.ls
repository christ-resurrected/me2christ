# see https://jeffkreeftmeijer.com/nodejs-purge-minify-css/
Chalk   = require \chalk
Cssnano = require \cssnano
Postcss = require \postcss
Uglijs  = require \uglify-js

module.exports = me =
  enabled: true
  toggle-enabled: -> me.enabled = not me.enabled

  css: ->>
    function process mat then Postcss([Cssnano!]).process(mat[1]).then(-> mat[0].replace mat[1], it.css)
    minify \css, \style, it, process

  html-comments: ->
    return it unless me.enabled
    it.replace /<!--(.*?)-->/g ''

  js: ->>
    function process mat then new Promise (resolve, reject) ->
      res = Uglijs.minify mat[1]
      if res.error then reject res.error else resolve mat[0].replace mat[1], res.code
    minify \js, \script, it, process

async function minify filetype, tag, html, process
  return html unless me.enabled
  const RX = new RegExp "<#tag>(.+?)<\/#tag>" \gs  # livescript renders /regex/gs as /regex/g.s
  promises = [...html.matchAll RX].map process
  replacements = await Promise.all promises
  out = html.replace RX, -> replacements.shift!
  delta = html.length - out.length
  percent = (100 * delta / html.length).toFixed 2
  log Chalk.yellow "Reduced #filetype by #{delta.toLocaleString!} bytes (#percent%)"
  out
