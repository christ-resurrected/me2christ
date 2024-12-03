Fs   = require \fs
Http = require \https
Path = require \path
Sh   = require \shelljs
Dir  = require \./constants .dir

module.exports =
  download-kjv-json: ->
    const FNAME = \verses-1769.json
    const FPATH = \https://raw.githubusercontent.com/farskipper/kjv/refs/heads/master/json/
    Http.get (url = FPATH + FNAME), (res) ->
      return log "ERROR #{res.statusCode} #key #url" unless res.statusCode is 200
      data = ''
      res.on \data -> data += it
      res.on \end ->
        try
          Sh.mkdir \-p Dir.SRC_SITE_RESOURCE
          Fs.writeFileSync (opath = Path.resolve Dir.SRC_SITE_RESOURCE, FNAME), data
          log "wrote #{data.length} bytes to #opath"
        catch err then log err

