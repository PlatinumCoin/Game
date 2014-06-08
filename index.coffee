express = require 'express'
partials = require 'express-partials'
socket = require 'socket.io'
http = require 'http'
uuid = require 'node-uuid'

# create servers instances
app = express()
server = http.createServer app
io = socket.listen server

# controllers
homeCtrl = require './controllers/home'
lobbyCtrl = require './controllers/lobby'
gameCtrl = require './controllers/game'

# express configuration
app.set 'port', process.env.PORT or 1337
app.set 'views', 'views'
app.set 'view engine', 'ejs'

# express middlewares
app.use partials()
app.use express.compress()
app.use '/public', express.static 'public'

# dummy GET request
app.get '/', homeCtrl.index
app.get '/lobby', lobbyCtrl.index
app.get '/game/:gameId?', gameCtrl.index

# start express server
app.listen app.get('port'), () ->
	console.log 'Server listening on port %d', app.get('port')

# server listen neighbour port
server.listen app.get('port') + 1

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
