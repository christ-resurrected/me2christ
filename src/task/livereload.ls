Ws = require \ws

expect-reconnect-count = 0
sockets = []

module.exports =
  notify: ->
    # log "reloading #{sockets.length} clients"
    # if clients are still reloading from previous notify, give them a chance to reconnect before sending the signal
    delay = if sockets.length < expect-reconnect-count then 500ms else 0ms
    setTimeout signal, delay

    function signal
      for ws in sockets then ws.send \reload
      expect-reconnect-count := sockets.length
      sockets := [] # should reconnect on reload

  start: ->
    wss = new Ws.WebSocketServer port: const PORT=7778
    log "Live-reload WebSocketServer listening on port #PORT"
    wss.on \connection (ws, req) ->
      log "New connection from #{req.socket.remoteAddress}"
      sockets.push ws
