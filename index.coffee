express = require 'express'
network = require './src/network-connection'
routes = require './src/routes-setup'
ports = require './ports'

# create servers instances
app = express()
sockets = network.createServer app

# express configuration
app.set 'view engine', 'jade'

# express middlewares
app.use express.compress()
app.use '/public', express.static 'public'

routes.setup app

# servers running
app.listen ports.express, () -> console.log 'info: server started'
sockets.server.listen ports.sockets
network.connection sockets.io
