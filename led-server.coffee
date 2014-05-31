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

app.get '/on/18', (req, res) ->
  io[18].set()
  res.send('on')

app.get '/off/18', (req, res) ->
  io[18].reset()
  clearInterval beatsInterval
  res.send('off')

app.get '/beats/18', (req, res) ->
  beatsInterval = setInterval ->
    io[18].set()
    setTimeout ->
      io[18].reset()
    , 200
  , 1000
  res.send('beats started')

app.get '/toggle/18', (req, res) ->
  if io[18].state == 0
    io[18].set()
  else
    io[18].reset()
  res.send("toggled to #{io[18].state == 0 ? 'on' : 'off'}")

io[18].on 'change', (val) ->
  # value will report either 1 or 0 (number) when the value changes
   io[18].state = val

io[22].on 'change', (val) ->
  console.log "22 changed to #{val}"

io[22].on 'change', (val) ->
  io[23].set(val)

app.listen app.get('port'), ->
  console.log "Listening on port #{app.get('port')}"
