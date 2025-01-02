Chalk = require \chalk
Fs    = require \fs
P     = require \path
Perf  = require \perf_hooks .performance
Pug   = require \pug
C     = require \./constants
Mcss  = require \./minify-css

const KJV = Fs.readFileSync C.KJVPATH, \utf8
const VERSES = JSON.parse(KJV.replaceAll '#' '')

opts =
  filters:
    hi: -> it.replace(/\*\*(.+?)\*\*/g, \<strong>$1</strong>).replace /\*(.+?)\*/g, \<em>$1</em>  # highlights
    link: ->
      for m in [...it.matchAll /\((http.+?)\)/g] then me.external-links.push m[1]
      it.replace /\[(.+?)\]\((.+?)\)/g "<a href='$2'>$1</a>"
  VERSES:VERSES

module.exports = me =
  external-links: []

  render: (ipath, odir) ->>
    t1 = Perf.now!
    me.external-links = []
    html = await Mcss.minify Pug.renderFile ipath, opts
    opath = P.resolve odir, P.basename ipath.replace /.(pug)$/, \.html
    Fs.writeFileSync opath, html
    log Chalk.green "Rendered #{html.length} bytes to #opath in #{(Perf.now! - t1).toFixed(0)}ms"
