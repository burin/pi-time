#!/bin/sh

if [ $(ps -e -o uid,cmd | grep $UID | grep -v grep | wc -l | tr -s "\n") -eq 0 ]
then
  cd /home/pi/deploy/pi-time
  NODE_JS_HOME=/home/pi/node-v0.10.16-linux-arm-pi

  export PATH=$PATH:$NODE_JS_HOME/bin
  export PATH=/usr/local/bin:$PATH
  node_modules/forever/bin/forever start -c node_modules/coffee-script/bin/coffee led-server.coffee
fi
