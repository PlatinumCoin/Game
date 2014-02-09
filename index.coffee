express = require 'express'
path = require 'path'

app = express()

homeCtrl = require './controllers/home'

app.set 'port', process.env.PORT || 1337
app.set 'views', path.join __dirname, 'views'
app.set 'view engine', 'ejs'
app.use express.static path.join __dirname, 'public'

# dummy GET request
app.get '/', homeCtrl.index

app.listen app.get('port'), () ->
	console.log 'Server listening on port %d', app.get('port')
