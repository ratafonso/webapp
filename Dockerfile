FROM golang:1.15.7-buster
ENV GO111MODULE=on
ENV GOFLAGS=-mod=vendor
ENV APP_HOME /usr/src/app
WORKDIR $APP_HOME
COPY ["main.go", "./"]
RUN go get -u github.com/ratafonso/webapp
COPY . .
EXPOSE 8080

CMD ["main", "run"]