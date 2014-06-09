exports.index = (request, response) ->
	response.render 'home', title: 'Welcome to Hollow Point', user: request.user
