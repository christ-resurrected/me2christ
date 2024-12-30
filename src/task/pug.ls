Chalk = require \chalk
Fs    = require \fs
P     = require \path
Pug   = require \pug
Dir   = require \./constants .dir

const KJVNAME = \verses-1769.json
const KJVPATH = P.resolve Dir.SRC_SITE_RESOURCE, KJVNAME
const KJV = Fs.readFileSync KJVPATH, \utf8
const VERSES = JSON.parse(KJV.replaceAll '#' '')

module.exports = me =
  render: (ipath, odir) ->
    # log "Render #ipath to #odir"
    html = Pug.renderFile ipath, VERSES:VERSES
    opath = P.resolve odir, P.basename ipath.replace /.(pug)$/, \.html
    Fs.writeFileSync opath, html
    log Chalk.green "Rendered #ipath to #opath (#{html.length} bytes)"
