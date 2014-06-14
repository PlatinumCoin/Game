socket = io.connect 'http://localhost:8080'
window.network = socket

socket.emit 'request:join', GAME_ID
