FROM ubuntu:22.04 as runner

RUN apt-get update && \
    apt-get install -y curl wget tar gawk sed ca-certificates

WORKDIR /app
COPY ./aleo-miner /app/aleo-miner
COPY ./aleo.sh /app/aleo.sh
RUN chmod +x aleo.sh && chmod +x aleo-miner

#CMD sh -c "./aleo-pool-prover --proxy ${PROXY_URL} --address ${ADDRESS} --worker-name ${WORKER_NAME}"
CMD sh -c "./aleo-miner -u stratum+tcp://aleo-asia.f2pool.com:4400 -w ${WORKER_NAME}"
