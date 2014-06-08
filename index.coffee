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
	client.uuid = uuid.v1()

	client.join 'game'

	allEnemies = io.sockets.clients 'game'
		.filter (socket) -> socket.uuid != client.uuid
		.map (socket) -> socket.uuid

	client.on 'message', (data) ->
		client.broadcast.to('game').emit "update:#{client.uuid}", data

	client.on 'disconnect', () ->
		client.broadcast.to('game').emit "remove:#{client.uuid}"

	client.emit 'sync', allEnemies

	client.broadcast.to('game').emit 'newClient', client.uuid

	console.log 'client %s connected', client.uuid
