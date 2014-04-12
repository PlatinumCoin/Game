exports.index = (request, response) ->
	response.render 'lobby', games: [
		{ hash: 'horde-unleashed', name: 'Horde Unleashed', players: 2, max: 5 }
		{ hash: 'welcome-to-reality', name: 'Welcome to Reality', players: 15, max: 15 }
	]
