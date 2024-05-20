FROM golang:1.22 as builder

RUN apt-get update && \
    apt-get install -y git make build-essential

WORKDIR /code

RUN git clone https://github.com/initia-labs/initia.git

WORKDIR /code/initia

RUN git pull && git checkout v0.2.15 && LEDGER_ENABLED=false make build

RUN cp /go/pkg/mod/github.com/initia\-labs/movevm@v*/api/libmovevm.x86_64.so /lib/libmovevm.so
RUN cp /go/pkg/mod/github.com/initia\-labs/movevm@v*/api/libcompiler.x86_64.so /lib/libcompiler.so

FROM ubuntu:22.04 as runner

RUN apt-get update && \
    apt-get install -y sed curl jq lz4 tar expect

WORKDIR /app

COPY --from=builder /code/initia/build/initiad /usr/local/bin/initiad
COPY --from=builder /lib/libmovevm.so /lib/libmovevm.x86_64.so
COPY --from=builder /lib/libcompiler.so /lib/libcompiler.x86_64.so

RUN initiad version

COPY init.sh /app/init.sh
RUN chmod +x /app/init.sh



