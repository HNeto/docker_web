# syntax=docker/dockerfile:1
FROM ubuntu
WORKDIR c:\container\psga_web\
COPY . .
RUN apt update && apt install -y curl && apt install -y git && apt install -y vim && apt install -y net-tools
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash
RUN apt install -y nodejs
RUN npm install -g npm@latest && npm install -g n && npm install -g yarn && npm install -g pm2
RUN n 16.13.2
RUN mkdir srv/PSGA_WEB && mkdir srv/PSGA_WEB/PSGA_WEB && mkdir srv/PSGA_WEB/PSGA_WEB_API 
RUN cd srv/PSGA_WEB/PSGA_WEB_API/
RUN git clone http://192.168.2.55:3000/psw/back-end-web-cotacao .
RUN echo "//CONFIG_SISTEM_AUTH_SECRET = '61f5bfbb41d57aa766cd04bfb3d629b0'" > .env && echo "//CONFIG_SISTEM_AUTH_EXPIRE = '7d'" >> .env && echo "//CONFIG_SISTEM_ID_OPCIONAL = '61f5bfbb41d57aa766cd04bfb3d629b0'" >> .env && echo "//CONFIG_SISTEM_PW_OPCIONAL = '61f5bfbb41d57aa766cd04bfb3d629b0'" >> .env && echo "//CONFIG_SISTEM_SERVER_PORT = '3001'" >> .env && echo "//CONFIG_SISTEM_SQL_VERSION = '12'" >> .env && echo "" >> .env && echo "CONFIG_SISTEM_AUTH_API_FRONT = 'http://localhost:3000/'" >> .env && echo "" >> .env && echo "CONFIG_DB_HOST = 'SWF-FAZENDAS' // host banco de dados" >> .env && echo "CONFIG_DB_USER = 'user' // usuario banco de dados" >> .env && echo "CONFIG_DB_PASS = '*****' // senha banco de dados" >> .env && echo "CONFIG_DB_BASE = 'PSGA' // nome do banco de dados" >> .env && echo "" >> .env && echo "CONFIG_MAIL_HOST = 'smtp.gmail.com'" >> .env && echo "CONFIG_MAIL_PORT = '465'" >> .env && echo "CONFIG_MAIL_USER = 'teste@mail.com'" >> .env && echo "CONFIG_MAIL_PASS = 'password'" >> .env
RUN yarn
RUN cd /srv/PSGA_WEB/PSGA_WEB/
RUN git clone http://192.168.2.55:3000/psw/front-end-web-cotacao .
RUN mv .env.exemple .env
RUN yarn
RUN cd /srv/
RUN echo "module.exports = {" > .ecosystem.config.js && echo "    apps : [{" >> .ecosystem.config.js && echo "        name: 'PSGA_WEB_BACK'," >> .ecosystem.config.js && echo "        cwb: '/srv/PSGA_WEB/PSGA_WEB_API/'," >> .ecosystem.config.js && echo "        exec_mode: 'fork'," >> .ecosystem.config.js && echo "        watch: 'true'," >> .ecosystem.config.js && echo "        script: 'cd /srv/PSGA_WEB/PSGA_WEB_API/ && yarn start'," >> .ecosystem.config.js && echo "        env: {" >> .ecosystem.config.js && echo "            NODE_ENV: 'production'" >> .ecosystem.config.js && echo "        }" >> .ecosystem.config.js && echo "    }, {" >> .ecosystem.config.js && echo "        name: 'PSGA_WEB_FRONT'," >> .ecosystem.config.js && echo "        cwb: '/srv/PSGA_WEB/PSGA_WEB/'," >> .ecosystem.config.js && echo "        exec_mode: 'fork'," >> .ecosystem.config.js && echo "        watch: 'true'," >> .ecosystem.config.js && echo "        script: 'cd /srv/PSGA_WEB/PSGA_WEB && yarn start'," >> .ecosystem.config.js && echo "        env: {" >> .ecosystem.config.js && echo "            NODE_ENV: 'production'" >> .ecosystem.config.js && echo "        }" >> .ecosystem.config.js && echo "    }]" >> .ecosystem.config.js && echo "};" >> .ecosystem.config.js
RUN pm2 install pm2-server-monit && pm2 start .ecosystem.config.js
CMD ["pm2", "monit"]
EXPOSE 3001