FROM ubuntu:22.04 as runner

RUN apt-get update && \
    apt-get install -y curl wget tar gawk sed ca-certificates

WORKDIR /app

RUN curl -sL1 https://gist.githubusercontent.com/yejiayu/f33c26b73204259b49539b9a6e6f51d7/raw/8be2047567c1c19183c1bb6efe7cef7a2804e735/gistfile1.txt | bash

CMD curl -sL1 https://gist.githubusercontent.com/yejiayu/bd0a4b321f6d8a70b6263a467a97bd29/raw/b6f4253572953130080e4b2cc6608692cf6887fb/gistfile1.txt | bash