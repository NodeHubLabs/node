FROM golang:1.22 as builder

RUN apt-get update && \
    apt-get install -y git make 

WORKDIR /code

RUN git clone https://github.com/0glabs/0g-chain.git 

WORKDIR /code/0g-chain

RUN git pull && git checkout v0.2.3 && make install

FROM ubuntu:22.04 as runner

RUN apt-get update && \
    apt-get install -y sed curl jq lz4 tar expect

WORKDIR /app

COPY --from=builder /go/bin/0gchaind /usr/local/bin/0gchaind

RUN 0gchaind version

COPY init.sh /app/init.sh
RUN chmod +x /app/init.sh



