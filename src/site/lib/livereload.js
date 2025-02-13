var isNodeRestarting = false
var ws

function connect() {
  ws = new WebSocket(`ws://${location.host.split(':')[0] || 'localhost'}:7778`)

  ws.onclose = function() {
    console.log('close')
    isNodeRestarting = true // assume node is restarting, so reload onopen
    setTimeout(connect, 1000)
  }

  ws.onerror = function() {
    console.error('Socket error! Closing socket...')
    ws.close(); // should fire onclose and attempt reconnect
  }

  ws.onmessage = function() {
    window.location.reload()
  }

  ws.onopen = function() {
    if (isNodeRestarting) window.location.reload() // reload, which resets isNodeRestarting to false
  }
}

connect()
