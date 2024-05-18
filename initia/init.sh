flag_file="$HOME/.initia/flag_init"

echo "SEEDS = $SEEDS"
echo "PEERS = $PEERS"
echo "GENESIS_URL = $GENESIS_URL"
echo "ADDRBOOK_URL = $ADDRBOOK_URL"
echo "CHAIN_ID  = $CHAIN_ID"
echo "MONIKER = $MONIKER"
echo "ORACLE_URL = $ORACLE_URL"
echo "RECOVER_FROM_SNAPSHOTS = $RECOVER_FROM_SNAPSHOTS"

if [ -f "$flag_file" ]; then
    echo "Flag file exists. Starting directly."
else
    echo "Starting init"
    initiad init $MONIKER --chain-id $CHAIN_ID

    # genesis
    curl -Ls $GENESIS_URL > $HOME/.initia/config/genesis.json

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


# These idiotic project teams all use the same framework, and yet they can't even standardize their RPC ports. It's ridiculous.
sed -i 's/laddr = "tcp:\/\/127\.0\.0\.1:26657"/laddr = "tcp:\/\/0.0.0.0:26657"/' $HOME/.initia/config/config.toml
sed -i 's/laddr = "tcp:\/\/127\.0\.0\.1:27857"/laddr = "tcp:\/\/0.0.0.0:27857"/' $HOME/.initia/config/config.toml

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
curl -Ls $ADDRBOOK_URL > $HOME/.initia/config/addrbook.json
sed -i "s/^persistent_peers = .*/persistent_peers = \"$PEERS\"/" $HOME/.initia/config/config.toml
sed -i "s/^seeds = .*/seeds = \"$SEEDS\"/" $HOME/.initia/config/config.toml