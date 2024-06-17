FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y wget

WORKDIR /app

RUN wget https://github.com/airchains-network/tracks/releases/download/v0.0.2/celestia
RUN wget https://github.com/airchains-network/tracks/releases/download/v0.0.2/celestia-key

RUN chmod +x ./celestia
RUN chmod +x ./celestia-key