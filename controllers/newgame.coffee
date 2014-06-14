exports.index = (request, response) ->
	response.render 'newgame', { user: request.user }
