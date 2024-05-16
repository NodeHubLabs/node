FROM golang:1.22 as Builder

WORKDIR /app

RUN git clone https://github.com/skip-mev/slinky.git

WORKDIR /app/slinky

RUN git checkout v0.4.3
RUN make build

FROM ubuntu:22.04 as Runner

WORKDIR /app

COPY oracle.json .

COPY --from=builder /app/slinky/build/slinky .
