express = require 'express'
gpio = require 'gpio'
app = express()
gpio18 = gpio.export 18
gpio23 = gpio.export 23
gpio22 = gpio.export 22, {
   direction: 'in'
}

beatsInterval = null

app.configure ->
  app.set 'port', process.env.PORT or 4000


app.get '/hello.txt', (req, res) ->
  res.send('Hello World')


app.get '/on/18', (req, res) ->
  gpio18.set()
  res.send('on')


app.get '/off/18', (req, res) ->
  gpio18.reset()
  clearInterval beatsInterval
  res.send('off')

app.get '/beats/18', (req, res) ->
  beatsInterval = setInterval ->
    gpio18.set()
    setTimeout ->
      gpio18.reset()
    , 200
  , 1000
  res.send('beats started')



app.get '/toggle/18', (req, res) ->
  if gpio18.state == 0
    gpio18.set()
  else
    gpio18.reset()
  res.send("toggled to #{gpio18.state == 0 ? 'on' : 'off'}")


gpio18.on 'change', (val) ->
  # value will report either 1 or 0 (number) when the value changes
   gpio18.state = val


gpio22.on 'change', (val) ->
  console.log "22 changed to #{val}"

gpio22.on 'change', (val) ->
  gpio23.set(val)


app.listen app.get('port'), ->
  console.log "Listening on port #{app.get('port')}"
