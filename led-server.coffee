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
  res.send('on')

app.get '/off/:id', (req, res) ->
  io[req.params.id].reset()
  clearInterval beatsInterval
  res.send('off')

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
    io[req.params.id].set()
  else
    io[req.params.id].reset()
  res.send("toggled to #{io[req.params.id].value}")

# tie the button to the led
io[22].on 'change', (val) ->
  io[23].set(val)

app.listen app.get('port'), ->
  console.log "Listening on port #{app.get('port')}"
