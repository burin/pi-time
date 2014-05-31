#### install raspian
#### enable ssh

#### install zeroconf

`sudo apt-get install libnss-mdns`

#### install wifi

`sudo apt-get install wicd-curses`

`sudo wicd-curses`

#### install nodejs

`wget http://nodejs.org/dist/v0.10.16/node-v0.10.16-linux-arm-pi.tar.gz`

`tar -xvzf node-v0.10.16-linux-arm-pi.tar.gz`

`node-v0.10.16-linux-arm-pi/bin/node --version`


#### add to ~/.profile

```
NODE_JS_HOME=/home/pi/node-v0.10.16-linux-arm-pi

PATH=$PATH:$NODE_JS_HOME/bin
```

#### enable gpio without sudo

http://stackoverflow.com/questions/12133860/accessing-the-gpio-of-a-raspberry-pi-without-sudo

#### hackity

https://learn.adafruit.com/raspberry-pi-e-mail-notifier-using-leds/wire-leds

https://github.com/EnotionZ/GpiO

`npm install -g coffee-script`