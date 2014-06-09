exports.index = (request, response) ->
	response.render 'home', { title: 'Hollow Point', user: request.user }
