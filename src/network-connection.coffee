socket = require 'socket.io'
http = require 'http'
uuid = require 'node-uuid'
games = require './game-manager'

exports.createServer = (hostServer) ->
	server = http.createServer hostServer
	io = socket.listen server

	{ io, server }

exports.connection = (io) ->
	io.sockets.on 'connection', (client) ->
		client.id = uuid.v1()

		broadcast = (client) ->
			client.broadcast.to client.game

		enemies = (game, clientId) ->
			io.sockets.clients game
				.map (client) -> client.id
				.filter (id) -> id isnt clientId

		client.on 'request:join', (game) ->
			throw new Error "game #{game} doesn't exist" if not games.exists game

			client.game = game

			client.join game
			games.addPlayer game

			broadcast(client).emit 'new:client', client.id
			client.emit 'request:sync', enemies(game, client.id)

		client.on 'request:update', (data) ->
			broadcast(client).emit "update:#{client.id}", data

		client.on 'disconnect', () ->
			broadcast(client).emit "remove:#{client.id}"
			client.leave client.game
			games.removePlayer client.game

		console.log 'client %s connected', client.id
