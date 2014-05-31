express = require 'express'
gpio = require 'gpio'
beatsInterval = null

io = {
  18: gpio.export 18
  23: gpio.export 23
  22: gpio.export 22, {
     direction: 'in'
  }
}

app = express()

app.configure ->
  app.set 'port', process.env.PORT or 4000

app.get '/on/:id', (req, res) ->
  io[req.params.id].set()
  res.send("#{req.params.id} on<br> <a href=\"/off/#{req.params.id}\">turn off</a>")

app.get '/off/:id', (req, res) ->
  io[req.params.id].reset()
  clearInterval beatsInterval
  res.send("#{req.params.id} off<br> <a href=\"/on/#{req.params.id}\">turn on</a>")

app.get '/beats/:id', (req, res) ->
  beatsInterval = setInterval ->
    io[req.params.id].set()
    setTimeout ->
      io[req.params.id].reset()
    , 200
  , 1000
  res.send('beats started')

app.get '/toggle/:id', (req, res) ->
  if io[req.params.id].value == 0
    io[req.params.id].set ->
      res.send("toggled to #{io[req.params.id].value}<br> <a href=\"/toggle/#{req.params.id}\">toggle</a>")
  else
    io[req.params.id].set 0, ->
      res.send("toggled to #{io[req.params.id].value}<br> <a href=\"/toggle/#{req.params.id}\">toggle</a>")


# tie the button to the led
io[22].on 'change', (val) ->
  io[23].set(val)

app.listen app.get('port'), ->
  console.log "Listening on port #{app.get('port')}"


exitHandler = (options, err) ->
  for k, v of io
    console.log "unexporting #{k}"
    gpio.unexport k
  if options.cleanup
    console.log('cleaning')
  if err
    console.log(err.stack)
  if options.exit
    process.exit()


# do something when app is closing
process.on('exit', exitHandler.bind(null,{ cleanup: true }))

# catches ctrl+c event
process.on('SIGINT', exitHandler.bind(null, { exit: true }))

# catches uncaught exceptions
process.on('uncaughtException', exitHandler.bind(null, { exit: true }))
