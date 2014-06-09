express = require 'express'
network = require './src/network-connection'
routes = require './src/routes-setup'
ports = require './ports'

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
