# syntax=docker/dockerfile:1
FROM ubuntu
WORKDIR /srv/
RUN apt update && apt install -y curl && apt install -y git && apt install -y vim && apt install -y net-tools
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash
RUN apt install -y nodejs
RUN npm install -g npm@latest && npm install -g n && npm install -g yarn && npm install -g pm2
RUN n 16.13.2
RUN mkdir /srv/PSGA_WEB/ && mkdir /srv/PSGA_WEB/PSGA_WEB/ && mkdir /srv/PSGA_WEB/PSGA_WEB_API/ 
RUN git clone http://example.com/PSGA_WEB_API /srv/PSGA_WEB/PSGA_WEB_API/
RUN echo "//CONFIG_SISTEM_AUTH_SECRET = '61f5bfbb41d57aa766cd04bfb3d629b0'" > /srv/PSGA_WEB/PSGA_WEB_API/.env && echo "//CONFIG_SISTEM_AUTH_EXPIRE = '7d'" >> /srv/PSGA_WEB/PSGA_WEB_API/.env && echo "//CONFIG_SISTEM_ID_OPCIONAL = '61f5bfbb41d57aa766cd04bfb3d629b0'" >> /srv/PSGA_WEB/PSGA_WEB_API/.env && echo "//CONFIG_SISTEM_PW_OPCIONAL = '61f5bfbb41d57aa766cd04bfb3d629b0'" >> /srv/PSGA_WEB/PSGA_WEB_API/.env && echo "//CONFIG_SISTEM_SERVER_PORT = '3001'" >> /srv/PSGA_WEB/PSGA_WEB_API/.env && echo "//CONFIG_SISTEM_SQL_VERSION = '12'" >> /srv/PSGA_WEB/PSGA_WEB_API/.env && echo "" >> /srv/PSGA_WEB/PSGA_WEB_API/.env && echo "CONFIG_SISTEM_AUTH_API_FRONT = 'http://localhost:3000/'" >> /srv/PSGA_WEB/PSGA_WEB_API/.env && echo "" >> /srv/PSGA_WEB/PSGA_WEB_API/.env && echo "CONFIG_DB_HOST = '192.168.0.0' // host banco de dados" >> /srv/PSGA_WEB/PSGA_WEB_API/.env && echo "CONFIG_DB_USER = 'user' // usuario banco de dados" >> /srv/PSGA_WEB/PSGA_WEB_API/.env && echo "CONFIG_DB_PASS = '*****' // senha banco de dados" >> /srv/PSGA_WEB/PSGA_WEB_API/.env && echo "CONFIG_DB_BASE = 'PSGA' // nome do banco de dados" >> /srv/PSGA_WEB/PSGA_WEB_API/.env && echo "" >> /srv/PSGA_WEB/PSGA_WEB_API/.env && echo "CONFIG_MAIL_HOST = 'smtp.gmail.com'" >> /srv/PSGA_WEB/PSGA_WEB_API/.env && echo "CONFIG_MAIL_PORT = '465'" >> /srv/PSGA_WEB/PSGA_WEB_API/.env && echo "CONFIG_MAIL_USER = 'teste@mail.com'" >> /srv/PSGA_WEB/PSGA_WEB_API/.env && echo "CONFIG_MAIL_PASS = 'password'" >> /srv/PSGA_WEB/PSGA_WEB_API/.env
RUN cd /srv/PSGA_WEB/PSGA_WEB_API/ && yarn
RUN git clone http://example.com/PSGA_WEB /srv/PSGA_WEB/PSGA_WEB/
RUN mv /srv/PSGA_WEB/PSGA_WEB/.env.exemple /srv/PSGA_WEB/PSGA_WEB/.env
RUN cd /srv/PSGA_WEB/PSGA_WEB/ && yarn
RUN echo "module.exports = {" > .ecosystem.config.js && echo "    apps : [{" >> .ecosystem.config.js && echo "        name: 'PSGA_WEB_BACK'," >> .ecosystem.config.js && echo "        cwb: '/srv/PSGA_WEB/PSGA_WEB_API/'," >> .ecosystem.config.js && echo "        exec_mode: 'fork'," >> .ecosystem.config.js && echo "        watch: 'true'," >> .ecosystem.config.js && echo "        script: 'cd /srv/PSGA_WEB/PSGA_WEB_API/ && yarn start'," >> .ecosystem.config.js && echo "        env: {" >> .ecosystem.config.js && echo "            NODE_ENV: 'production'" >> .ecosystem.config.js && echo "        }" >> .ecosystem.config.js && echo "    }, {" >> .ecosystem.config.js && echo "        name: 'PSGA_WEB_FRONT'," >> .ecosystem.config.js && echo "        cwb: '/srv/PSGA_WEB/PSGA_WEB/'," >> .ecosystem.config.js && echo "        exec_mode: 'fork'," >> .ecosystem.config.js && echo "        watch: 'true'," >> .ecosystem.config.js && echo "        script: 'cd /srv/PSGA_WEB/PSGA_WEB && yarn start'," >> .ecosystem.config.js && echo "        env: {" >> .ecosystem.config.js && echo "            NODE_ENV: 'production'" >> .ecosystem.config.js && echo "        }" >> .ecosystem.config.js && echo "    }]" >> .ecosystem.config.js && echo "};" >> .ecosystem.config.js
RUN pm2 install pm2-server-monit
CMD ["pm2-runtime", "start", "/srv/.ecosystem.config.js"]
EXPOSE 3000 3001 1433
