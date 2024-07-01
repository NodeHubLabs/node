FROM ubuntu:22.04 as runner

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y wget tar git jq curl wget expect vim

WORKDIR /root/hubble

RUN curl -L "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

COPY hubble.sh /root/hubble/hubble.sh
RUN chmod +x /root/hubble/hubble.sh

ENTRYPOINT ["/bin/bash", "-c", "/root/hubble/hubble.sh upgrade"]


