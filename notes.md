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


#### deployment

http://www.deanoj.co.uk/programming/git/using-git-and-a-post-receive-hook-script-for-auto-deployment/

http://clock.co.uk/blog/deploying-nodejs-apps


##### Configure ~/.ssh/config
```
cat ~/.ssh/config

Host pi
  HostName raspberrypi.local
  User pi
```

##### set up the deploy dir on the pi

`mkdir -p /home/pi/deploy/pi-time`

##### Make a bare repo on the pi

```
mkdir -p /home/pi/git-repos/pi-time
cd /home/pi/git-repos/pi-time

git init --bare

vi hooks/post-receive
```

Put this in the `hooks/post-receive`:

```
#!/usr/bin/env bash
 
set -u
set -e

NODE_JS_HOME=/home/pi/node-v0.10.16-linux-arm-pi

PATH=$PATH:$NODE_JS_HOME/bin
export GIT_WORK_TREE="/home/pi/deploy/pi-time"
export NODE_VERSION="0.10"
 
echo "--> Checking out..."
git checkout -f
 
echo "--> Installing libraries..."
cd "$GIT_WORK_TREE"
npm install

echo "--> Stopping app"
node_modules/forever/bin/forever stop led-server.coffee

echo "--> Starting app"
node_modules/forever/bin/forever start -c node_modules/coffee-script/bin/coffee led-server.coffee
 
```

Make the `post-receive` hook executable:

`chmod +x post-receive`


##### Add the remote on the dev machine

```

git remote add pi ssh://pi/home/pi/git-repos/pi-time

git remote -v

git push pi master


```


#### set up the deploy junk

`mkdir -p /home/pi/deploy/pi-time`



https://gist.github.com/tlrobinson/8035884


#### vi ~/git-repos/pi-time/hooks/post-receive

```
#!/usr/bin/env bash
 
set -u
set -e

NODE_JS_HOME=/home/pi/node-v0.10.16-linux-arm-pi

PATH=$PATH:$NODE_JS_HOME/bin
export GIT_WORK_TREE="/home/pi/deploy/pi-time"
export NODE_VERSION="0.10"
 
echo "--> Checking out..."
git checkout -f
 
echo "--> Installing libraries..."
cd "$GIT_WORK_TREE"
npm install

echo "--> Stopping app"
node_modules/forever/bin/forever stop led-server.coffee

echo "--> Starting app"
node_modules/forever/bin/forever start -c node_modules/coffee-script/bin/coffee led-server.coffee
 

```



##### Restarting forever with cron on reboot

https://www.digitalocean.com/community/articles/how-to-host-multiple-node-js-applications-on-a-single-vps-with-nginx-forever-and-crontab

`crontab -e`

Add this to the end of the file:

`@reboot /home/pi/deploy/pi-time/starter.sh`