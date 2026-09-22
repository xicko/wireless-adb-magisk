#!/system/bin/sh

MODDIR=${0%/*}
CONF="/data/adb/wireless_adb.conf"
DEFAULT_PORT="5555"

if [ ! -f "$CONF" ]; then
    echo "$DEFAULT_PORT" > "$CONF"
fi

PORT=$(head -n 1 "$CONF" | tr -cd '0-9')

if [ -z "$PORT" ]; then
    PORT="$DEFAULT_PORT"
fi

while [ "$(getprop sys.boot_completed)" != "1" ]; do
    sleep 2
done

sleep 3

setprop service.adb.tcp.port "$PORT"
stop adbd
start adbd