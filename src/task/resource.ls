Fs   = require \fs
Http = require \https
Path = require \path
C    = require \./constants
Dir  = require \./constants .dir

const KJVNAME = \verses-1769.json
const KJVPATH = Path.resolve Dir.SRC_SITE_RESOURCE, KJVNAME

module.exports =
  download-kjv: ->
    const URL = \https://raw.githubusercontent.com/farskipper/kjv/refs/heads/master/json/verses-1769.json
    Http.get URL, (res) ->
      return log "ERROR #{res.statusCode} #URL" unless res.statusCode is 200
      data = ''
      res.on \data -> data += it
      res.on \end ->
        try
          if !Fs.existsSync Dir.SRC_SITE_RESOURCE then Fs.mkdirSync Dir.SRC_SITE_RESOURCE
          Fs.writeFileSync KJVPATH, data
          log "wrote #{data.length} bytes to #KJVPATH"
        catch err then log err
