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

mongoose.connect 'mongodb://localhost/hollow-point'
mongoose.model 'User', UserSchema

User = mongoose.model 'User'

# servers instances
app = express()
sockets = network.createServer app

# express configuration
app.set 'view engine', 'jade'

# express middlewares
app.use express.compress()
app.use '/public', express.static 'public'

routes.setup app

# servers running
app.listen ports.express
sockets.server.listen ports.sockets

# socket.io connection
network.connection sockets.io
