Fs   = require \fs
Http = require \https
Path = require \path
Sh   = require \shelljs
C    = require \./constants
Dir  = require \./constants .dir

const KJVNAME = \verses-1769.json
const KJVPATH = Path.resolve Dir.SRC_SITE_RESOURCE, KJVNAME

module.exports =
  download-kjv-json: ->
    const URL = \https://raw.githubusercontent.com/farskipper/kjv/refs/heads/master/json/verses-1769.json
    Http.get URL, (res) ->
      return log "ERROR #{res.statusCode} #URL" unless res.statusCode is 200
      data = ''
      res.on \data -> data += it
      res.on \end ->
        try
          Sh.mkdir \-p Dir.SRC_SITE_RESOURCE
          Fs.writeFileSync KJVPATH, data
          log "wrote #{data.length} bytes to #KJVPATH"
        catch err then log err

  generate-verses-json: ->
    verses = Fs.readFileSync KJVPATH, \utf8
    Fs.writeFileSync C.VERSES_PATH, data = JSON.stringify(verses: JSON.parse verses.replaceAll '#' '')
    log "wrote #{data.length} bytes to #{C.VERSES_PATH}"
