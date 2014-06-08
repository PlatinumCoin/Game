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
	# TODO: get hash
	# TODO: use exists()
	if name not in games
		games[name] =
			name: name,
			hash: name,
			players: 0,
			max: maxPlayersCount

exports.addPlayer = (hash) ->
	games[hash].players += 1

exports.removePlayer = (hash) ->
	games[hash].players -= 1

exports.gamesList = () ->
	Object.keys games
		.map (key) -> games[key]

exports.exists = (hash) ->
	hash in games
