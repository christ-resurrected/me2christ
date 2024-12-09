Ws = require \ws

sockets = []

module.exports =
  notify: ->
    # log "reloading #{sockets.length} clients"
    for ws in sockets then ws.send \reload
    sockets := [] # should reconnect on reload

  start: ->
    wss = new Ws.WebSocketServer port: const PORT=7778
    log "Live-reload WebSocketServer listening on port #PORT"
    wss.on \connection (ws, req) ->
      # log "New connection from #{req.socket.remoteAddress}"
      sockets.push ws
