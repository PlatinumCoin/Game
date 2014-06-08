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
app.listen ports.express, () -> console.log "Server listening on port #{ ports.express }"
server.listen ports.sockets

# socket connection options
io.sockets.on 'connection', (client) ->
	client.uuid = uuid.v1()

	client.emit 'connected', id: client.uuid

	client.on 'message', (message) ->
		client.broadcast.emit 'tick', { message, id: client.uuid }

	client.on 'connectTo', (gameId) ->
		client.join gameId
		console.log "client join #{ gameId }"

		clients = io.sockets.clients(gameId).map (client) -> client.uuid

		console.log clients
		io.sockets.in(gameId).emit 'clientsListUpdate', clients

	client.on 'disconnect', () ->
		console.log "#{client.uuid} was disconnected"
