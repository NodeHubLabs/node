FROM golang:1.22 as builder

RUN apt-get update && \
    apt-get install -y git make build-essential sudo python3 python3-pip

WORKDIR /code

RUN git clone https://github.com/swanchain/go-computing-provider.git

WORKDIR /code/go-computing-provider

RUN git pull && git checkout releases && make clean && make && make install

ENV CP_PATH=/code/go-computing-provider
RUN ./install.sh

FROM ubuntu:22.04 as runner

RUN apt-get update && \
    apt-get install -y python3 python3-pip

WORKDIR /app

COPY --from=builder /code/go-computing-provider/computing-provider /app/computing-provider
COPY --from=builder /code/go-computing-provider/inference-model /app/inference-model

RUN /app/computing-provider -v



