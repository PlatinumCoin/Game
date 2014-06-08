socket = io.connect 'http://localhost:8080'

socket.on 'connected', (params) ->
	# Params :: Object { id }
	socket.emit 'connectTo', GAME_ID

socket.on 'tick', () ->
	console.log arguments

socket.on 'clientsListUpdate', () ->
	console.log arguments

bumpButton = document.getElementById 'bump'

bumpButton.addEventListener 'click', () ->
	socket.emit 'message', 'bump'
