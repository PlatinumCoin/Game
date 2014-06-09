exports.index = (request, response) ->
	gameManager = require '../src/game-manager'
	games = gameManager.gamesList()

	response.render 'lobby', { games, user: request.user }
