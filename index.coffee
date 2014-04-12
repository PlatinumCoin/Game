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

# start express server
app.listen app.get('port'), () ->
	console.log 'Server listening on port %d', app.get('port')

# server listen neighbour port
server.listen app.get('port') + 1

# socket connection options
io.sockets.on 'connection', (client) ->
	client.uuid = uuid.v1()

	client.emit 'onconnected', id: client.uuid

	client.on 'message', (message) ->
		console.log client.uuid, message

	client.on 'disconnect', () ->
		console.log client.uuid
