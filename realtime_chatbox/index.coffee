express = require('express')
app = express()
http = require('http').Server(app)
io = require('socket.io')(http)

app.use express.static("#{__dirname}/public")


io.on 'connection', (socket) ->

  socket.on 'add user', (username) =>
    socket.username = username
    console.log 'a user connected'
    socket.emit 'login'
    socket.broadcast.emit 'user connect', username

  socket.on 'disconnect', () ->
    console.log 'user disconnected'
    io.emit 'user disconnect', 'user'

  socket.on 'typing', () ->
    socket.broadcast.emit 'typing', username: socket.username

  socket.on 'stop typing', () ->
    socket.broadcast.emit 'stop typing', username: socket.username


  socket.on 'new message', (data) ->
    socket.broadcast.emit('new message', {
     username: socket.username,
     message: data
    })


http.listen 3000, () ->
  console.log 'listening on *:3000'