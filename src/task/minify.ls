# see https://jeffkreeftmeijer.com/nodejs-purge-minify-css/
Chalk   = require \chalk
Cssnano = require \cssnano
Postcss = require \postcss
Uglijs  = require \uglify-js

module.exports = me =
  enabled: process.env.NODE_ENV is \production
  toggle-enabled: -> me.enabled = not me.enabled

  # In css and js process functions:
  #
  # m is the regex match
  # m[0] includes enclosing tags
  # m[1] is capture group 1 containing the original code excluding tags

  css: ->>
    function process m then Postcss([Cssnano!]).process(m.1).then(-> m.0.replace m.1, it.css)
    minify \css, \style, it, process

  html-comments: ->
    return it unless me.enabled
    it.replace /<!--(.*?)-->/g ''

  js: ->>
    function process m then new Promise (resolve, reject) ->
      res = Uglijs.minify m.1
      if res.error then reject res.error else resolve m.0.replace m.1, res.code
    minify \js, \script, it, process

async function minify filetype, tag, html, process
  return html unless me.enabled
  const RE = new RegExp "<#tag>(.+?)<\/#tag>" \gs  # livescript renders /regex/gs as /regex/g.s
  promises = [...html.matchAll RE].map process
  replacements = await Promise.all promises
  out = html.replace RE, -> replacements.shift!
  delta = html.length - out.length
  percent = (100 * delta / html.length).toFixed 2
  log Chalk.yellow "Reduced #filetype by #{delta.toLocaleString!} bytes (#percent%)"
  out
