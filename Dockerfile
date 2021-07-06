FROM golang:1.15.7-buster
ENV GO111MODULE=on
ENV GOFLAGS=-mod=vendor
ENV APP_HOME /app
WORKDIR $APP_HOME
COPY ["main.go", "./"]
COPY . .
EXPOSE 8080

CMD ["go", "build", "main.go"]