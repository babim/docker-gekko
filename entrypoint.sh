#!/bin/bash

sed -i 's/127.0.0.1/0.0.0.0/g' /usr/src/app/web/vue/UIconfig.js
sed -i 's/localhost/'${HOST}'/g' /usr/src/app/web/vue/UIconfig.js
sed -i 's/3000/'${PORT}'/g' /usr/src/app/web/vue/UIconfig.js

if [[ -z "${DRIVER}" ]]; then
sed -i 's/sqlite/'${DRIVER}'/g' /usr/src/app/web/vue/UIconfig.js
fi

exec "$@"
