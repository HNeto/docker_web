# syntax=docker/dockerfile:1
FROM ubuntu
WORKDIR /srv/
RUN apt update && apt install -y curl && apt install -y git && apt install -y vim
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash
RUN apt install -y nodejs
RUN npm install -g npm@latest && npm install -g n && npm install -g yarn && npm install -g pm2
RUN n 16.13.2
RUN mkdir /srv/APP_WEB/ && mkdir /srv/APP_API/ && mkdir /srv/APP_WEB/WEB_FRONT/ && mkdir /srv/APP_WEB/WEB_BACK/

RUN git clone http://gitexample.com/project/app-apis /srv/APP_API/
RUN echo "//CONFIG_SISTEM_AUTH_SECRET = '61f5bfbb41d57aa766cd04bfb3d629b0'" > /srv/APP_API/.env && echo "//CONFIG_SISTEM_AUTH_EXPIRE = '7d'" >> /srv/APP_API/.env && echo "CONFIG_SISTEM_SERVER_PORT = '3002'" >> /srv/APP_API/.env && echo "" >> /srv/APP_API/.env && echo "CONFIG_SISTEM_AUTH_API_FRONT = 'http://localhost:3000/'" >> /srv/APP_API/.env && echo "" >> /srv/APP_API/.env && echo "CONFIG_DB_HOST = '192.168.0.0'" >> /srv/APP_API/.env && echo "CONFIG_DB_USER = 'user'" >> /srv/APP_API/.env && echo "CONFIG_DB_PASS = '********'" >> /srv/APP_API/.env && echo "CONFIG_DB_BASE = 'DBNAME'" >> /srv/APP_API/.env && echo "" >> /srv/APP_API/.env && echo "CONFIG_MAIL_HOST = 'smtp.gmail.com'" >> /srv/APP_API/.env && echo "CONFIG_MAIL_PORT = '465'" >> /srv/APP_API/.env && echo "CONFIG_MAIL_USER = 'example@gmail.com'" >> /srv/APP_API/.env && echo "CONFIG_MAIL_PASS = '********'" >> /srv/APP_API/.env
RUN cd /srv/APP_API/ && yarn

RUN git clone http://gitexample.com/project/web_back /srv/APP_WEB/WEB_BACK/
RUN echo "//CONFIG_SISTEM_AUTH_SECRET = '61f5bfbb41d57aa766cd04bfb3d629b0'" > /srv/APP_WEB/WEB_BACK/.env && echo "//CONFIG_SISTEM_AUTH_EXPIRE = '7d'" >> /srv/APP_WEB/WEB_BACK/.env && echo "//CONFIG_SISTEM_ID_OPCIONAL = '61f5bfbb41d57aa766cd04bfb3d629b0'" >> /srv/APP_WEB/WEB_BACK/.env && echo "//CONFIG_SISTEM_PW_OPCIONAL = '61f5bfbb41d57aa766cd04bfb3d629b0'" >> /srv/APP_WEB/WEB_BACK/.env && echo "//CONFIG_SISTEM_SERVER_PORT = '3001'" >> /srv/APP_WEB/WEB_BACK/.env && echo "//CONFIG_SISTEM_SQL_VERSION = '12'" >> /srv/APP_WEB/WEB_BACK/.env && echo "" >> /srv/APP_WEB/WEB_BACK/.env && echo "CONFIG_SISTEM_AUTH_API_FRONT = 'http://localhost:3000/'" >> /srv/APP_WEB/WEB_BACK/.env && echo "" >> /srv/APP_WEB/WEB_BACK/.env && echo "CONFIG_DB_HOST = '192.168.0.0' // host banco de dados" >> /srv/APP_WEB/WEB_BACK/.env && echo "CONFIG_DB_USER = 'user' // usuario banco de dados" >> /srv/APP_WEB/WEB_BACK/.env && echo "CONFIG_DB_PASS = '********' // senha banco de dados" >> /srv/APP_WEB/WEB_BACK/.env && echo "CONFIG_DB_BASE = 'DBNAME' // nome do banco de dados" >> /srv/APP_WEB/WEB_BACK/.env && echo "" >> /srv/APP_WEB/WEB_BACK/.env && echo "CONFIG_MAIL_HOST = 'smtp.gmail.com'" >> /srv/APP_WEB/WEB_BACK/.env && echo "CONFIG_MAIL_PORT = '465'" >> /srv/APP_WEB/WEB_BACK/.env && echo "CONFIG_MAIL_USER = 'example@gmail.com'" >> /srv/APP_WEB/WEB_BACK/.env && echo "CONFIG_MAIL_PASS = '********'" >> /srv/APP_WEB/WEB_BACK/.env
RUN cd /srv/APP_WEB/WEB_BACK/ && yarn

RUN git clone http://example.com/project/web_front /srv/APP_WEB/APP_FRONT/
RUN mv /srv/APP_WEB/APP_FRONT/.env.exemple /srv/APP_WEB/APP_FRONT/.env
RUN cd /srv/APP_WEB/APP_FRONT/ && yarn

RUN cd /srv/
RUN echo "module.exports = {" > .ecosystem.config.js && echo "    apps: [{" >> .ecosystem.config.js && echo "        name: 'WEB_BACK'," >> .ecosystem.config.js && echo "        cwb: '/srv/APP_WEB/WEB_BACK/'," >> .ecosystem.config.js && echo "        exec_mode: 'fork'," >> .ecosystem.config.js && echo "        watch: 'true'," >> .ecosystem.config.js && echo "        script: 'cd /srv/APP_WEB/WEB_BACK/ && yarn start'," >> .ecosystem.config.js && echo "        env: {" >> .ecosystem.config.js && echo "            NODE_ENV: 'production'" >> .ecosystem.config.js && echo "        }" >> .ecosystem.config.js && echo "    }, {" >> .ecosystem.config.js && echo "        name: 'WEB_FRONT'," >> .ecosystem.config.js && echo "        cwb: '/srv/APP_WEB/WEB_FRONT/'," >> .ecosystem.config.js && echo "        exec_mode: 'fork'," >> .ecosystem.config.js && echo "        watch: 'true'," >> .ecosystem.config.js && echo "        script: 'cd /srv/APP_WEB/WEB_FRONT && yarn start'," >> .ecosystem.config.js && echo "        env: {" >> .ecosystem.config.js && echo "            NODE_ENV: 'production'" >> .ecosystem.config.js && echo "        }" >> .ecosystem.config.js && echo "    }, {" >> .ecosystem.config.js  && echo "        name: 'APP_API'," >> .ecosystem.config.js && echo "        cwb: '/srv/APP_API/'," >> .ecosystem.config.js && echo "        exec_mode: 'fork'," >> .ecosystem.config.js && echo "        watch: 'true'," >> .ecosystem.config.js && echo "        script: 'cd /srv/APP_API/ && yarn start'," >> .ecosystem.config.js && echo "        env: {" >> .ecosystem.config.js && echo "            NODE_ENV: 'production'" >> .ecosystem.config.js && echo "        }" >> .ecosystem.config.js && echo "    }]" >> .ecosystem.config.js && echo "};" >> .ecosystem.config.js
RUN pm2 install pm2-server-monit

CMD ["pm2-runtime", "start", "/srv/.ecosystem.config.js"]

EXPOSE 3000 3001 3002 1433
