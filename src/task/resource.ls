Fs   = require \fs
Http = require \https
Path = require \path
Sh   = require \shelljs
Dir  = require \./constants .dir
KjvPath = require \./constants .KJVPATH

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
          Fs.writeFileSync KjvPath, data
          log "wrote #{data.length} bytes to #KjvPath"
        catch err then log err

