FROM node:6.3
# Maintainer
# ----------
MAINTAINER babim <babim@matmagoc.com>

RUN rm -f /etc/motd && \
    echo "---" > /etc/motd && \
    echo "Support by Duc Anh Babim. Contact: ducanh.babim@yahoo.com" >> /etc/motd && \
    echo "---" >> /etc/motd && \
    touch "/(C) Babim"
#envi
ENV LC_ALL en_US.UTF-8
ENV TZ Asia/Ho_Chi_Minh

# envi app
ENV HOST localhost
ENV PORT 3000

# babim
RUN apt-get update && apt-get install nano htop telnet git wget python python-pip -y
RUN npm install mongojs --save && npm install postgresql && npm install random-ext
# babim closed

# prepare startup
RUN mkdir -p /start/ \
WORKDIR /start
    
# Bundle app source
RUN git clone https://github.com/askmike/gekko.git && cd gekko && npm install --production && \
    git clone https://github.com/gekkowarez/gekkoga.git && cd gekkoga && npm install && cd .. && \
    git clone https://github.com/Gab0/gekkoJaponicus && cd gekkoJaponicus && pip install -r requirements.txt && cd .. && \
    cd .. && \
    npm install -g node-gyp && \
    cd $(npm root -g)/npm && npm install fs-extra && sed -i -e s/graceful-fs/fs-extra/ -e s/fs.rename/fs.move/ ./lib/utils/rename.js
RUN npm install redis@0.10.0 talib@1.0.2 pg@6.1.0

# Create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# clean
RUN apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove -y && \
    rm -rf /build && \
    rm -rf /tmp/* /var/tmp/* && \
    rm -rf /var/lib/apt/lists/* && \
    rm -f /etc/dpkg/dpkg.cfg.d/02apt-speedup

# make startup
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 3000
CMD [ "npm", "start" ]
