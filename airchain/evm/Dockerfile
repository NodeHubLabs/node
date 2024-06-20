FROM golang:1.22 as builder

RUN apt-get update && \
    apt-get install -y git make build-essential

WORKDIR /code

RUN git clone https://github.com/yejiayu/evm-station.git

WORKDIR /code/evm-station

RUN go mod tidy && go build -o ./build/station-evm ./cmd/station-evmd/main.go

FROM ubuntu:22.04 as runner

RUN apt-get update && \
    apt-get install -y jq

WORKDIR /app

COPY --from=builder /code/evm-station/build/station-evm /usr/local/bin/station-evm
COPY --from=builder /code/evm-station/scripts/local-setup.sh /app/local-setup.sh
COPY --from=builder /code/evm-station/scripts/local-start.sh /app/local-start.sh

COPY init.sh /app/init.sh
RUN chmod +x /app/init.sh

RUN station-evm -h
