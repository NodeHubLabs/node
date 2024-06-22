FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y wget

WORKDIR /app

RUN wget https://github.com/airchains-network/tracks/releases/download/v0.0.2/avail-node
RUN wget https://github.com/airchains-network/tracks/releases/download/v0.0.2/avail-light

RUN chmod +x ./avail-node
RUN chmod +x ./avail-light