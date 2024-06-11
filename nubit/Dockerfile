FROM ubuntu:22.04 as runner

RUN apt-get update && \
    apt-get install -y curl wget tar

WORKDIR /app

RUN ARCH=$(uname -m) && OS=$(uname -s) && \
    if [ "$ARCH" = "arm64" ] && [ "$OS" = "Darwin" ]; then \
        ARCH_STRING="darwin-arm64"; \
    elif [ "$ARCH" = "x86_64" ] && [ "$OS" = "Darwin" ]; then \
        ARCH_STRING="darwin-x86_64"; \
    elif [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then \
        ARCH_STRING="linux-arm64"; \
    elif [ "$ARCH" = "x86_64" ]; then \
        ARCH_STRING="linux-x86_64"; \
    elif [ "$ARCH" = "i386" ] || [ "$ARCH" = "i686" ]; then \
        ARCH_STRING="linux-x86"; \
    else \
        echo "Unsupported architecture: $ARCH"; exit 1; \
    fi \
    && wget http://nubit.sh/nubit-bin/nubit-node-$ARCH_STRING.tar \
    && tar -xvf nubit-node-$ARCH_STRING.tar \
    && mv nubit-node-$ARCH_STRING nubit-node \
    && rm nubit-node-$ARCH_STRING.tar

