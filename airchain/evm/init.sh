flag_file="$HOME/$APP_DATA_DIR/flag_init"
if [ -f "$flag_file" ]; then
    echo "Flag file exists. Starting directly."
else
    echo "Starting init"

    sh /app/local-setup.sh
    touch "$flag_file"
    echo "create init flag file"
fi