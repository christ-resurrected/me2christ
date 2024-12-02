var ws

function connect() {
  ws = new WebSocket(`ws://${location.host.split(':')[0] || 'localhost'}:7778`)

  ws.onmessage = function() {
    window.location.reload()
  }

  ws.onclose = function() { // e.g. if node restarts
    console.log('close')
    setTimeout(connect, 1000)
  }

  ws.onerror = function(err) {
    console.error('Socket encountered error: ', err.message, 'Closing socket');
    ws.close(); // should fire onclose and attempt reconnect
  }
}

connect()
