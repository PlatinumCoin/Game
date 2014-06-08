express = require 'express'
socket = require 'socket.io'
ports = require './ports'
uuid = require 'node-uuid'
http = require 'http'

# create servers instances
app = express()
server = http.createServer app
io = socket.listen server

# express configuration
app.set 'view engine', 'jade'

# express middlewares
app.use express.compress()
app.use '/public', express.static 'public'

# controllers
homeCtrl = require './controllers/home'
lobbyCtrl = require './controllers/lobby'
gameCtrl = require './controllers/game'

# getters
app.get '/', homeCtrl.index
app.get '/lobby', lobbyCtrl.index
app.get '/game/:gameId?', gameCtrl.index

# servers running
app.listen ports.express, () -> console.log 'info: server started'
server.listen ports.sockets

# socket connection options
io.sockets.on 'connection', (client) ->
	gameManager = require './src/game-manager'

	client.uuid = uuid.v1()
	broadcast = (client) -> client.broadcast.to client.game

	client.on 'request:join', (game) ->
		throw "game #{game} doesn't exist" if gameManager.exists game

		client.game = game

		enemies = io.sockets.clients game
			.map (socket) -> socket.uuid

		client.join game
		gameManager.addPlayer game

		broadcast(client).emit 'newClient', client.uuid
		client.emit 'request:sync', enemies

	client.on 'request:update', (data) ->
		broadcast(client).emit "update:#{client.uuid}", data

	client.on 'disconnect', () ->
		broadcast(client).emit "remove:#{client.uuid}"
		client.leave client.game
		gameManager.removePlayer game

	console.log 'client %s connected', client.uuid
