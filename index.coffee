express = require 'express'
path = require 'path'

app = express()

app.set 'port', process.env.PORT || 1337
app.set 'views', path.join __dirname, 'views'
app.set 'view engine', 'ejs'

# dummy GET request
app.get '/', (request, response) ->
	response.render 'index', title: 'Hello'

app.listen app.get('port'), () ->
	console.log 'Server listening on port %d', app.get('port')
