FROM golang:1.15.7-buster
ENV NODE_ENV=production
RUN go get -u github.com/ratafonso/webapp
WORKDIR /usr/src/app
COPY ["package.json", "package-lock.json*", "npm-shrinkwrap.json*", "./"]
RUN npm install --production --silent && mv node_modules ../
COPY . .
EXPOSE 3000
ENV DBHOST $DBHOST
ENV DBUSER $DBUSER
ENV DBPASS $DBPASS
ENV DBNAME $DBNAME

CMD ["yarn", "start"]