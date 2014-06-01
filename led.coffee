gpio = require 'gpio'
gpio18 = undefined
gpio23 = undefined
intervalTimer = undefined

# Flashing lights if LED connected to GPIO18
gpio18 = gpio.export 18,
  ready: ->
    intervalTimer = setInterval ->
      gpio18.set()
      setTimeout ->
        gpio18.reset()
      , 500
    , 1000


# Lets assume a different LED is hooked up to pin 23, the following code
# will make that LED blink inversely with LED from pin 18
gpio23 = gpio.export 23,
  ready: ->

    # bind to gpio18's change event
    gpio18.on 'change', (val) ->
      gpio23.set 1 - val # set gpio23 to the opposite valued

# reset the headers and unexport after 10 seconds
setTimeout ->
  clearInterval intervalTimer # stops the voltage cycling
  gpio18.removeAllListeners 'change' # unbinds change event
  gpio18.reset() # sets header to low
  gpio18.unexport() # unexport the header
  gpio23.reset()
  gpio23.unexport ->
    # unexport takes a callback which gets fired as soon as unexporting is done
    process.exit() # exits your node program
, 10000
