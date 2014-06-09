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
	# TODO: use POST
	app.get '/newgame', (request, response) ->
		games.newGame request.query['game-name'], request.query['game-count']

		response.redirect 301, '/lobby'
