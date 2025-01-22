Chalk   = require \chalk
Fs      = require \fs
P       = require \path
Perf    = require \perf_hooks .performance
Pug     = require \pug
C       = require \./constants
Flag    = require \./flag
Minify  = require \./minify

const KJV = Fs.readFileSync C.KJVPATH, \utf8
const OPTS =
  doctype: \html # fix lint html: do not self-close <img> tags
  filters:
    hi: -> # highlights
      tmp = it.replace /\*\*(.+?)\*\*/g \<strong>$1</strong>
      tmp.replace /\*(.+?)\*/g \<em>$1</em>
    link: ->
      for m in [...it.matchAll /\((http.+?)\)/g] then me.external-links.push m.1
      it.replace /\[(.+?)\]\((.+?)\)/g '<a href="$2">$1</a>'
    postcss: require \./pug-filter/postcss
    svg: require \./pug-filter/inline-svg
  VERSES: JSON.parse(KJV.replaceAll '#' '')

module.exports = me =
  external-links: []

  render: (ipath, odir) ->>
    t0 = Perf.now!
    me.external-links = []
    html = Pug.renderFile ipath, OPTS
    html = await Minify.js await Minify.css Minify.html-comments html if Flag.prod
    opath = P.resolve odir, P.basename ipath.replace /\.pug$/ \.html
    Fs.writeFileSync opath, html
    len = html.length.toLocaleString!
    prod = if Flag.prod then '' else Chalk.yellow "prod disabled"
    log Chalk.green "Rendered #len bytes to #opath in #{(Perf.now! - t0).toFixed 0}ms #prod"
