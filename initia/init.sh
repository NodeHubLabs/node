flag_file="$HOME/.initia/flag_init"

echo "NODE_NAME = $NODE_NAME"
echo "ORACLE_URL = $ORACLE_URL"
echo "RECOVER_FROM_SNAPSHOTS = $RECOVER_FROM_SNAPSHOTS"
echo "SEEDS = $SEEDS"
echo "PEERS = $PEERS"

if [ -f "$flag_file" ]; then
    echo "Flag file exists. Starting directly."
else
    echo "Starting init"
    initiad init $NODE_NAME --chain-id initiation-1

    # genesis
    curl -Ls https://snapshots.polkachu.com/testnet-genesis/initia/genesis.json > $HOME/.initia/config/genesis.json

    touch "$flag_file"
    echo "create init flag file"
fi

# Check if recovery from snapshots is needed
if [ "$RECOVER_FROM_SNAPSHOTS" = "true" ]; then
    echo "Recovering from snapshots..."
    # Back up priv_validator_state.json if needed
    cp $HOME/.initia/data/priv_validator_state.json $HOME/.initia/priv_validator_state.json

    initiad tendermint unsafe-reset-all --home $HOME/.initia --keep-addr-book

    lz4 -c -d $HOME/metadata/initia_latest.tar.lz4 | tar -x -C $HOME/.initia
    mv $HOME/.initia/priv_validator_state.json $HOME/.initia/data/priv_validator_state.json
fi


# setting minimum-gas-prices = "0.15uinit,0.01uusdc"
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.15uinit,0.01uusdc\"|" $HOME/.initia/config/app.toml

sed -i \
-e "s/^pruning *=.*/pruning = \"custom\"/" \
-e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" \
-e "s/^pruning-interval *=.*/pruning-interval = \"10\"/" \
"$HOME/.initia/config/app.toml"

# set oracle
sed -i 's/^enabled = .*/enabled = true/' $HOME/.initia/config/app.toml
sed -i 's/^production = .*/production = true/' $HOME/.initia/config/app.toml
sed -i "s/^oracle_address = .*/oracle_address = \"$ORACLE_URL\"/" $HOME/.initia/config/app.toml

echo "fetching latest network addr"
curl -Ls https://rpc-initia-testnet.trusted-point.com/addrbook.json > $HOME/.initia/config/addrbook.json
sed -i "s/^persistent_peers = .*/persistent_peers = \"$PEERS\"/" $HOME/.initia/config/config.toml
sed -i "s/^seeds = .*/seeds = \"$SEEDS\"/" $HOME/.initia/config/config.toml