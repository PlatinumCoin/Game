games = require './game-manager'

exports.setup = (app) ->
	# controllers
	homeCtrl = require '../controllers/home'
	lobbyCtrl = require '../controllers/lobby'
	gameCtrl = require '../controllers/game'

	# get
	app.get '/', homeCtrl.index
	app.get '/lobby', lobbyCtrl.index
	app.get '/game/:gameId?', gameCtrl.index

	# post
	app.post '/newgame', (request, response) ->
		games.newGame request.body['game-name'], request.body['game-count']

		response.redirect 301, '/lobby'
