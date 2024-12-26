Chalk = require \chalk
Ws    = require \ws

expect-reconnect-count = 0
sockets = []

module.exports =
  notify: ->
    # if clients are still reloading from previous notify, give them a chance to reconnect before sending the signal
    const DELAY = 500ms
    delay = if sockets.length < expect-reconnect-count then DELAY else 0ms
    if delay is DELAY then log Chalk.yellow "Waiting #{DELAY}ms for #{expect-reconnect-count} clients to reconnect"
    setTimeout signal, delay

    function signal
      # log Chalk.yellow "reloading #{sockets.length} clients"
      for ws in sockets then ws.send \reload
      expect-reconnect-count := sockets.length
      sockets := [] # should reconnect on reload

  start: ->
    wss = new Ws.WebSocketServer port: const PORT=7778
    log "Live-reload WebSocketServer listening on port #PORT"
    wss.on \connection (ws, req) ->
      # log Chalk.yellow "New connection from #{req.socket.remoteAddress}"
      sockets.push ws
