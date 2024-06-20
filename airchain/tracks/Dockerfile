FROM golang:1.22 as builder

RUN apt-get update && \
    apt-get install -y git make build-essential

WORKDIR /code

RUN git config --global http.postBuffer 524288000
RUN git config --global http.maxRequestBuffer 100M
RUN git config --global http.version HTTP/1.1

RUN git clone https://github.com/yejiayu/tracks.git

WORKDIR /code/tracks

RUN go mod tidy && go build -o ./build/tracks ./cmd/main.go

FROM ubuntu:22.04 as runner

RUN apt-get update && \
    apt-get install -y ca-certificates

WORKDIR /app

COPY --from=builder /code/tracks/build/tracks /usr/local/bin/tracks

RUN tracks -h
