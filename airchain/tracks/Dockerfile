FROM golang:1.22 as builder

RUN apt-get update && \
    apt-get install -y git make build-essential

WORKDIR /code

RUN git clone https://github.com/airchains-network/tracks.git

WORKDIR /code/tracks

RUN go mod tidy && go build -o ./build/tracks ./cmd/main.go

FROM ubuntu:22.04 as runner

WORKDIR /app

COPY --from=builder /code/tracks/build/tracks /usr/local/bin/tracks

RUN tracks -h
