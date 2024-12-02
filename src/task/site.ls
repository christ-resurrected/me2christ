Http = require \http
Ns   = require \node-static
Dir  = require \./constants .dir

const PORT=7777

module.exports =
  start: (cb) ->
    ns = new Ns.Server Dir.BUILD_SITE
    s = Http.createServer (req, resp) ->
      l = req.addListener \end -> ns.serve req, resp
      l.resume!
    s.listen PORT, ->
      log "Http server listening on port #PORT"
      cb!
