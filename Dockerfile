FROM golang:1.15.7-buster
ENV APP_USER app
ENV APP_HOME /go/src/app
ENV GO111MODULE=on
ENV GOFLAGS=-mod=vendor
ENV APP_HOME /app
RUN groupadd $APP_USER && useradd -m -g $APP_USER -l $APP_USER
RUN mkdir -p $APP_HOME
RUN mkdir /app
RUN go mod download
RUN go mod verify
RUN go build -o serasa
WORKDIR $APP_HOME
USER $APP_USER
COPY ["main.go", "./"]
COPY . .
EXPOSE 8080

CMD ["./serasa"]