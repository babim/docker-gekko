FROM node:8
MAINTAINER babim <babim@matmagoc.com>

ENV HOST localhost
ENV PORT 3000

# Create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Install GYP dependencies globally, will be used to code build other dependencies
RUN npm install -g --production node-gyp && \
    npm cache clean --force

# Install app dependencies
RUN apt-get update && apt-get install -y wget git bash nano
RUN wget https://raw.githubusercontent.com/askmike/gekko/stable/package.json
RUN npm install --production && \
    npm install --production redis@0.10.0 talib@1.0.2 tulind@0.8.7 pg && \
    npm install mongojs --save && npm install postgresql && npm install mongodb && \
    npm cache clean --force

# Bundle app source
RUN git clone https://github.com/askmike/gekko.git && mv gekko/* . && rm -rf gekko && \
    npm install --production && cp sample-config.js config.js

# clean
RUN apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove -y && \
    rm -rf /build && \
    rm -rf /tmp/* /var/tmp/* && \
    rm -rf /var/lib/apt/lists/* && \
    rm -f /etc/dpkg/dpkg.cfg.d/02apt-speedup

EXPOSE 3000
# make startup
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD [ "npm", "start" ]
