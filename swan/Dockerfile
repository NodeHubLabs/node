FROM golang:1.22 as builder

RUN apt-get update && \
    apt-get install -y git make build-essential sudo python3 python3-pip

WORKDIR /code

RUN git clone https://github.com/yejiayu/go-computing-provider.git

WORKDIR /code/go-computing-provider

RUN git pull && git checkout fix-ubi && make clean && make && make install

ENV CP_PATH /code/go-computing-provider
RUN ./install.sh

FROM ubuntu:22.04 as runner

RUN apt-get update && \
    apt-get install -y ca-certificates

WORKDIR /app

COPY --from=builder /code/go-computing-provider/computing-provider /app/computing-provider
COPY --from=builder /code/go-computing-provider/inference-model /app/inference-model

ENV CP_PATH /app

RUN /app/computing-provider -v
