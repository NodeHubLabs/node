FROM ubuntu:22.04 as runner

RUN apt-get update && \
    apt-get install -y wget tar git

WORKDIR /app

RUN git clone https://github.com/CESSProject/cess-nodeadm

WORKDIR /app/cess-nodeadm

RUN git checkout v0.5.6 && ./install.sh

