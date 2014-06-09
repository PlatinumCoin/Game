games =
	'horde-unleashed':
		hash: 'horde-unleashed'
		name: 'Horde Unleashed'
		players: 0
		max: 5

	'welcome-to-reality':
		hash: 'welcome-to-reality'
		name: 'Welcome to Reality'
		players: 0
		max: 15

exports.newGame = (name, maxPlayersCount) ->
	slugify = require 'string-slugify'
	hash = slugify name

	if not exports.exists hash
		games[hash] =
			name: name
			hash: hash
			players: 0
			max: +maxPlayersCount

exports.addPlayer = (hash) ->
	if exports.exists hash
		games[hash].players += 1

exports.removePlayer = (hash) ->
	if exports.exists hash
		games[hash].players -= 1

exports.gamesList = () ->
	Object.keys games
		.map (key) -> games[key]

exports.exists = (hash) ->
	games.hasOwnProperty hash
