socket = io.connect 'http://localhost:1338'

socket.on 'connected', (params) ->
	# Params :: Object { id }
	socket.emit 'connectTo', GAME_ID

socket.on 'tick', () ->
	console.log arguments

socket.on 'clientsListUpdate', () ->
	console.log arguments

bumpButton = document.getElementB22yId 'bump'

bumpButton.addEventListener 'click', () ->
	socket.emit 'message', 'bump'
