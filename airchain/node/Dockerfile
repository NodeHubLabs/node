FROM golang:1.22 as builder

RUN apt-get update && \
    apt-get install -y git make 

WORKDIR /code

RUN git clone https://github.com/airchains-network/junction 

WORKDIR /code/junction

RUN git checkout v0.1.0 && go build -o build/junctiond cmd/junctiond/main.go

FROM ubuntu:22.04 as runner
RUN apt-get update && \
    apt-get install -y sed curl jq lz4 tar expect ca-certificates

WORKDIR /app

COPY --from=builder /code/junction/build/junctiond /usr/local/bin/junctiond

RUN junctiond version

COPY init.sh /app/init.sh
RUN chmod +x /app/init.sh
