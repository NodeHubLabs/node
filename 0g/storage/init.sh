echo "RPC_ENDPOINT = $RPC_ENDPOINT"
echo "MINER_KEY = $MINER_KEY"
echo "DB_DIR = $DB_DIR"
echo "NETWORK_DIR = $NETWORK_DIR"
echo "STORAGE_BOOT_NODES = $STORAGE_BOOT_NODES"
echo "STORAGE_BOOT_NODES = $STORAGE_BOOT_NODES"
echo "LOG_SYNC_START_BLOCK_NUMBER = $LOG_SYNC_START_BLOCK_NUMBER"
echo "LOG_CONTRACT_ADDRESS = $LOG_CONTRACT_ADDRESS"

FILE="/app/config.toml"

sed -i "s|^blockchain_rpc_endpoint = .*|blockchain_rpc_endpoint = \"$RPC_ENDPOINT\"|" "$FILE"
sed -i "s|^miner_key = .*|miner_key = \"$MINER_KEY\"|" "$FILE"
sed -i "s|^#\? *db_dir *= *.*|db_dir = \"$DB_DIR\"|" "$FILE"
sed -i "s|^#\? *network_dir *= *.*|network_dir = \"$NETWORK_DIR\"|" "$FILE"
sed -i "s|^# \(rpc_enabled = true\)|\1|" "$FILE"
STORAGE_BOOT_NODES=$(echo $STORAGE_BOOT_NODES | sed "s/^'//;s/'$//")
sed -i.bak "s|^network_boot_nodes = .*|network_boot_nodes = $STORAGE_BOOT_NODES|" config.toml
sed -i "s|^log_sync_start_block_number = .*|log_sync_start_block_number = $LOG_SYNC_START_BLOCK_NUMBER |" "$FILE"
sed -i "s|^log_contract_address = .*|log_contract_address = \"$LOG_CONTRACT_ADDRESS\" |" "$FILE"