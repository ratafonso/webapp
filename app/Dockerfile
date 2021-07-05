FROM node:12.18-alpine

ENV NODE_ENV=production
ENV DBHOST $DBHOST
ENV DBUSER $DBUSER
ENV DBPASS $DBPASS
ENV DBNAME $DBNAME

WORKDIR /src/app
ADD package.json package.json
ADD index.js index.js
RUN npm install
