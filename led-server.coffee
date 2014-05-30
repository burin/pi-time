express = require 'express'
gpio = require 'gpio'
app = express()
gpio18 = gpio.export 18

app.configure ->
  app.set "port", process.env.PORT or 4000


app.get '/hello.txt', (req, res) ->
  res.send('Hello World')


app.get '/on/18', ->
  gpio18.set()


app.get '/off/18', ->
  gpio18.reset()


app.listen app.get('port'), ->
  console.log "Listening on port #{app.get('port')}"
