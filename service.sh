#!/system/bin/sh

MODDIR=${0%/*}

while [ "$(getprop sys.boot_completed)" != "1" ]; do
    sleep 2
done

sleep 3

sh "$MODDIR/action.sh"