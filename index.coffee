express = require 'express'
partials = require 'express-partials'
path = require 'path'

app = express()

homeCtrl = require './controllers/home'

app.set 'port', process.env.PORT or 1337
app.set 'views', 'views'
app.set 'view engine', 'ejs'

app.use partials()
app.use express.compress()
app.use '/public', express.static 'public'

# dummy GET request
app.get '/', homeCtrl.index

app.listen app.get('port'), () ->
	console.log 'Server listening on port %d', app.get('port')
