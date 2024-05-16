FROM golang:1.22 as builder

RUN apt-get update && \
    apt-get install -y git make 

WORKDIR /code

RUN git clone https://github.com/artela-network/artela 

WORKDIR /code/artela

RUN git pull && git checkout v0.4.7-rc6 && make build

FROM ubuntu:22.04 as runner

RUN apt-get update && \
    apt-get install -y sed curl jq lz4 tar expect 

WORKDIR /app

COPY --from=builder /code/artela/build/artelad /usr/local/bin/artelad

RUN artelad version

COPY init.sh /app/init.sh
RUN chmod +x /app/init.sh



