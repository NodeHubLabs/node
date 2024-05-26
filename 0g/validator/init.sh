APP_DATA_DIR=.0gchain
flag_file="$HOME/$APP_DATA_DIR/flag_init"

echo "SEEDS = $SEEDS"
echo "PEERS = $PEERS"
echo "GENESIS_URL = $GENESIS_URL"
echo "ADDRBOOK_URL = $ADDRBOOK_URL"
echo "CHAIN_ID  = $CHAIN_ID"
echo "MONIKER = $MONIKER"
echo "RECOVER_FROM_SNAPSHOTS = $RECOVER_FROM_SNAPSHOTS"
echo "SNAP_FILE = $SNAP_FILE"

if [ -f "$flag_file" ]; then
    echo "Flag file exists. Starting directly."
else
    echo "Starting init"
    0gchaind init $MONIKER --chain-id $CHAIN_ID

    # genesis
    curl -Ls $GENESIS_URL > $HOME/$APP_DATA_DIR/config/genesis.json

    touch "$flag_file"
    echo "create init flag file"
fi

# Check if recovery from snapshots is needed
if [ "$RECOVER_FROM_SNAPSHOTS" = "true" ]; then
    echo "Recovering from snapshots..."
    # Back up priv_validator_state.json if needed
    cp $HOME/$APP_DATA_DIR/data/priv_validator_state.json $HOME/$APP_DATA_DIR/priv_validator_state.json

    0gchaind tendermint unsafe-reset-all --home $HOME/$APP_DATA_DIR --keep-addr-book

    lz4 -c -d $HOME/metadata/0g_latest.tar.lz4 | tar -x -C $HOME/$APP_DATA_DIR
    mv $HOME/$APP_DATA_DIR/priv_validator_state.json $HOME/$APP_DATA_DIR/data/priv_validator_state.json
fi


# setting minimum-gas-prices = "0.0025ua0gi"
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.0025ua0gi\"|" $HOME/$APP_DATA_DIR/config/app.toml

# These idiotic project teams all use the same framework, and yet they can't even standardize their RPC ports. It's ridiculous.
sed -i 's/laddr = "tcp:\/\/127\.0\.0\.1:26657"/laddr = "tcp:\/\/0.0.0.0:26657"/' $HOME/$APP_DATA_DIR/config/config.toml
sed -i 's/laddr = "tcp:\/\/127\.0\.0\.1:27857"/laddr = "tcp:\/\/0.0.0.0:27857"/' $HOME/$APP_DATA_DIR/config/config.toml

sed -i \
-e "s/^pruning *=.*/pruning = \"custom\"/" \
-e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" \
-e "s/^pruning-interval *=.*/pruning-interval = \"10\"/" \
"$HOME/$APP_DATA_DIR/config/app.toml"

echo "fetching latest network addr"
curl -Ls $ADDRBOOK_URL > $HOME/$APP_DATA_DIR/config/addrbook.json
sed -i "s/^persistent_peers = .*/persistent_peers = \"$PEERS\"/" $HOME/$APP_DATA_DIR/config/config.toml
sed -i "s/^seeds = .*/seeds = \"$SEEDS\"/" $HOME/$APP_DATA_DIR/config/config.toml