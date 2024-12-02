Ws = require \ws

const PORT=7778

sockets = []

module.exports =
  notify: ->
    # log "reloading #{sockets.length} clients"
    for ws in sockets then ws.send \reload
    sockets := [] # should reconnect on reload

  start: ->
    wss = new Ws.WebSocketServer {port:PORT}
    log "Live-reload WebSocketServer listening on port #PORT"
    wss.on \connection (ws, req) ->
      # log "New connection from #{req.socket.remoteAddress}"
      sockets.push ws
