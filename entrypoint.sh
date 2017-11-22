#!/bin/bash

# copy app
if [ -z "`ls /usr/src/app`" ]; then cp -R /start/gekko/* /usr/src/app; fi

# ssh
if [ -f "/runssh.sh" ]; then /runssh.sh; fi

# replace host config
sed -i 's/127.0.0.1/0.0.0.0/g' /usr/src/app/web/vue/UIconfig.js
sed -i 's/localhost/'${HOST}'/g' /usr/src/app/web/vue/UIconfig.js
sed -i 's/3000/'${PORT}'/g' /usr/src/app/web/vue/UIconfig.js

exec "$@"
