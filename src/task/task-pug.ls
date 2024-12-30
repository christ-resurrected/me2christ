Chalk = require \chalk
Fs    = require \fs
P     = require \path
Perf  = require \perf_hooks .performance
Pug   = require \pug
C     = require \./constants

const KJV = Fs.readFileSync C.KJVPATH, \utf8
const VERSES = JSON.parse(KJV.replaceAll '#' '')

opts =
  filters:
    hl: -> it.replace(/\*\*(.+?)\*\*/g, \<strong>$1</strong>).replace /\*(.+?)\*/g, \<em>$1</em>  # highlights
    link: -> it.replace(/\[(.+?)\]\((.+?)\)/g, "<a href='$2'>$1</a>")
  VERSES:VERSES

module.exports =
  render: (ipath, odir) ->
    t1 = Perf.now!
    html = Pug.renderFile ipath, opts
    opath = P.resolve odir, P.basename ipath.replace /.(pug)$/, \.html
    Fs.writeFileSync opath, html
    log Chalk.green "Rendered #{html.length} bytes to #opath in #{(Perf.now! - t1).toFixed(0)}ms"
