express = require 'express'
network = require './src/network-connection'
routes = require './src/routes-setup'
ports = require './ports'

mongoose = require 'mongoose'
passport = require 'passport'

Schema = mongoose.Schema
TwitterStrategy = require('passport-twitter').Strategy
{ consumerKey, consumerSecret } = require './twitter-keys.json'

UserSchema = new Schema
	provider: String
	uid: String
	name: String
	image: String
	created:
		type: Date
		default: Date.now
	metrics:
		games:
			type: Number
			default: 0
		kills:
			type: Number
			default: 0
		deaths:
			type: Number
			default: 0

mongoose.connect 'mongodb://localhost/hollow-point'
mongoose.model 'User', UserSchema

User = mongoose.model 'User'

callbackURL = "http://192.168.240.6:#{ports.express}/auth/twitter/callback"

passport.use new TwitterStrategy { consumerKey, consumerSecret, callbackURL },
	(token, tokenSecret, profile, done) ->
		User.findOne { uid: profile.id }, (error, user) ->
			if user
				done null, user
			else
				user = new User

				user.provider = 'twitter'
				user.uid = profile.id
				user.name = profile.displayName
				user.image = profile._json.profile_image_url

				user.save (error) ->
					throw error if error
					done null, user

passport.serializeUser (user, done) ->
	done null, user.uid

passport.deserializeUser (uid, done) ->
	User.findOne { uid }, done

# servers instances
app = express()
sockets = network.createServer app

# express configuration
app.set 'view engine', 'jade'

# express middlewares
app.use express.compress()
app.use express.bodyParser()
app.use express.cookieParser()
app.use express.session(secret: consumerSecret)
app.use passport.initialize()
app.use passport.session()
app.use '/public', express.static 'public'

app.get '/auth/twitter', passport.authenticate('twitter'), () ->

app.get '/auth/twitter/callback',
  passport.authenticate('twitter', { failureRedirect: '/login' }),
  (request, response) -> response.redirect '/'

app.get '/logout', (request, response) ->
  request.logout()
  response.redirect '/'

routes.setup app

# servers running
app.listen ports.express
sockets.server.listen ports.sockets

# socket.io connection
network.connection sockets.io
