#!/bin/bash

WORKSPACE="$(cd $(dirname $0) && pwd)"

LOG_PATH="$WORKSPACE/aleo-miner.log"
APP_PATH="$WORKSPACE/aleo-miner"
IP_PORT=$1
ACCOUNTNAME=$2

if [[ "$IP_PORT" == "" ]]; then
    echo "error: Expect 1 argument"
    exit 1
fi

if [[ "$ACCOUNTNAME" == "" ]]; then
    echo "error: Expect 2 argument"
    exit 1
fi

pkill -9 aleo-miner
nvidia-smi &>/dev/null && gpu_exists=1
cpu_cores=$(lscpu | grep '^CPU(s):' | awk '{print $2}')
physical_cores=$(( cpu_cores / 2 ))
cpu_span=16

unset TASTSET_CPU_CORES

if [[ $gpu_exists -eq 1 ]]; then
    nohup $APP_PATH -d 0 -u $IP_PORT -w $ACCOUNTNAME >> $LOG_PATH 2>&1 &
    echo "nohup $APP_PATH -d 0 -u $IP_PORT -w $ACCOUNTNAME >> $LOG_PATH 2>&1 &"
elif [[ $cpu_cores -eq 48 ]]; then
    nohup $APP_PATH -u $IP_PORT -w $ACCOUNTNAME >> $LOG_PATH 2>&1 &
    echo "nohup $APP_PATH -u $IP_PORT -w $ACCOUNTNAME >> $LOG_PATH 2>&1 &"
elif [[ $cpu_cores -le $((cpu_span * 2)) ]]; then
    cpu_list="0-$((cpu_cores - 1))"
    export TASTSET_CPU_CORES=$cpu_list && nohup taskset -c $cpu_list $APP_PATH -u $IP_PORT -w $ACCOUNTNAME >> $LOG_PATH 2>&1 &
    echo "nohup taskset -c $cpu_list $APP_PATH -u $IP_PORT -w $ACCOUNTNAME >> $LOG_PATH 2>&1 &"
else
    for index in $(seq 0 $cpu_span $((physical_cores - 1))); do
        l1=$index
        r1=$((l1 + cpu_span - 1))
        l2=$((index + physical_cores))
        r2=$((index + physical_cores + cpu_span - 1))
        [[ $r1 -gt $physical_cores ]] && r1=$((physical_cores - 1))
        [[ $r2 -gt $cpu_cores ]] && r2=$((cpu_cores - 1))

        cpu_list="$l1-$r1,$l2-$r2"
        export TASTSET_CPU_CORES=$cpu_list && nohup taskset -c $cpu_list $APP_PATH -u $IP_PORT -w $ACCOUNTNAME >> $LOG_PATH 2>&1 &
        echo "nohup taskset -c $cpu_list $APP_PATH -u $IP_PORT -w $ACCOUNTNAME >> $LOG_PATH 2>&1 &"
    done
fi