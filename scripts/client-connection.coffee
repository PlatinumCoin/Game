socket = io.connect 'http://localhost:1338'

socket.on 'connected', (params) ->
	# console.log params.id
	socket.emit 'connectTo', GAME_ID

socket.on 'tick', () ->
	console.log arguments


bumpButton = document.getElementById 'bump'

bumpButton.addEventListener 'click', () ->
	socket.emit 'message', 'bump'
