FROM rust:1.78.0 as builder

RUN apt-get update && \
    apt-get install -y git make cmake build-essential clang

WORKDIR /code
RUN git clone https://github.com/0glabs/0g-storage-node.git

WORKDIR /code/0g-storage-node

RUN git pull && git checkout v0.3.1 && git submodule update --init &&cargo build --release

FROM ubuntu:22.04 as runner

WORKDIR /app

COPY --from=builder /code/0g-storage-node/target/release/zgs_node /usr/local/bin/zgs_node
COPY --from=builder /code/0g-storage-node/run/config.toml /app/config.toml
COPY --from=builder /code/0g-storage-node/run/log_config /app/log_config

RUN zgs_node -V

COPY init.sh /app/init.sh
RUN chmod +x /app/init.sh