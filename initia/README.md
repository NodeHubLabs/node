# Initia

https://initia.xyz/ initia 测试网 Docker 一键部署

## Info

- 节点版本 version: https://github.com/initia-labs/initia/tree/v0.2.14

## How to run

```sh
$ git clone https://github.com/kantandadui/node
$ cd node/initia
$ docker-compose -f compose.yaml up -d
$ docker ps

```

## env

node/initia/.env 参数说明

```env
MARKET_MAP_ENDPOINT=initia:9090 # 默认不需要改，预言机依赖链数据的 URL
ORACLE_URL=initia-slinky:8080 # 默认不需要改，链依赖预言机数据的 URL

NODE_NAME=kantandadui # 改成你想给自己节点取的名字

SEEDS=id@ip:port # 从这里复制的 https://www.polkachu.com/testnets/initia/seeds，如果 seeds 失效可以去获取最新数据
PEERS=id@ip:port # 从这里复制的 https://www.polkachu.com/testnets/initia/peers，如果查看日志发现连上不上，可以去官方 dc 或者到刚才的网站去获取最新的

RECOVER_FROM_SNAPSHOTS=false # 是否从快照恢复，默认是从 0 开始同步，如果你想从快照恢复请设置为 true，然后参考下面文档。!首次启动成功后记得改为 false，否则下一次启动又会从快照复制一遍
SNAPSHOTS_PATH=/home/users/snapshots # 指定在你本地中存放下载好的快照文件夹
```

## 从快照恢复

从 0 区块高度开始同步区块比较慢，可以选择从快照恢复到距离最新不远的区块高度

最新快照可以从这里下载 https://www.polkachu.com/testnets/initia/snapshots

从命令行下载

```
$ wget https://snapshots.polkachu.com/testnet-snapshots/initia/initia_150902.tar.lz4 -o initia_latest.tar.lz4
```

或者你可以选择使用某种下载软件下载，总之下载好后请做 2 个修改

1. 修改 .env 的 RECOVER_FROM_SNAPSHOTS=true
2. 修改 .env 的 SNAPSHOTS_PATH 为你存放快照的文件夹路径，比如 /home/users/snapshots，注意到文件夹路径就行，不需要指定到文件

一切就绪后执行

```sh
$ docker-compose -f compose.yaml up -d
```

可以使用 docker ps 和 docker logs 查看运行状态，如果看到

```
Recovering from snapshots...
```

说明正在从快照恢复，由于快照文件较大需要解压和写入磁盘，启动时间可能较长
