games = require './game-manager'

exports.setup = (app) ->
	# controllers
	homeCtrl = require '../controllers/home'
	lobbyCtrl = require '../controllers/lobby'
	gameCtrl = require '../controllers/game'
	newgameCtrl = require '../controllers/newgame'

	# get
	app.get '/', homeCtrl.index
	app.get '/lobby', lobbyCtrl.index
	app.get '/game/:gameId?', gameCtrl.index
	app.get '/newgame', newgameCtrl.index

	# post
	app.post '/newgame', (request, response) ->
		game = games.newGame request.body['game-name'], request.body['game-count']

		response.redirect 301, "/#{ game.hash }"
