#!/system/bin/sh

CONF="/data/adb/wireless_adb.conf"
DEFAULT_PORT="5555"

PORT=$(head -n 1 "$CONF" | tr -cd '0-9')
[ -z "$PORT" ] && PORT="$DEFAULT_PORT"

setprop service.adb.tcp.port "${PORT}"
stop adbd
start adbd