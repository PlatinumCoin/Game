socket = io.connect 'http://192.168.0.183:8080'
window.network = socket

socket.emit 'request:join', GAME_ID
