FROM node:6.3

ENV HOST localhost
ENV PORT 3000

# Create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# babim
RUN apt-get update && apt-get install nano htop telnet git wget -y
RUN npm install mongojs --save && npm install random-ext
# babim closed

# Install app dependencies
RUN wget https://github.com/askmike/gekko/raw/stable/package.json
RUN npm install -g node-gyp
RUN cd $(npm root -g)/npm && npm install fs-extra && sed -i -e s/graceful-fs/fs-extra/ -e s/fs.rename/fs.move/ ./lib/utils/rename.js
RUN npm install --production
RUN npm install redis@0.10.0 talib@1.0.2 pg@6.1.0

# Bundle app source
RUN git clone https://github.com/askmike/gekko.git && git clone https://github.com/gekkowarez/gekkoga.git  && \
    mv gekko/* . && rm -rf gekko/

# prepare startup
RUN mkdir -p /start/gekko \
    && mv /usr/src/app/* /start/gekko

# clean
RUN apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove -y && \
    rm -rf /build && \
    rm -rf /tmp/* /var/tmp/* && \
    rm -rf /var/lib/apt/lists/* && \
rm -f /etc/dpkg/dpkg.cfg.d/02apt-speedup

# make starup
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 3000
CMD [ "npm", "start" ]
