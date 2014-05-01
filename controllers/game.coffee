exports.index = (request, response) ->
	if not request.params.gameId
		response.redirect 301, '/lobby'

	response.render 'game', title: request.params.gameId
