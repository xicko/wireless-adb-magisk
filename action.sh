#!/system/bin/sh

CONF="/data/adb/wireless_adb.conf"
DEFAULT_PORT="5555"

if [ ! -f "$CONF" ]; then
    cat << 'EOF' > "$CONF"
port=5555
allowTailnetOnly=false
EOF
elif ! grep -qi '^port=' "$CONF"; then
    OLD_CONF_PORT=$(head -n 1 "$CONF" 2>/dev/null | tr -cd '0-9')
    [ -z "$OLD_CONF_PORT" ] && OLD_CONF_PORT="$DEFAULT_PORT"
    cat << EOF > "$CONF"
port=$OLD_CONF_PORT
allowTailnetOnly=false
EOF
fi

cleanup() {
    p="$1"
    [ -z "$p" ] && return
    iptables -D INPUT -p tcp --dport "$p" -m state --state RELATED,ESTABLISHED -j ACCEPT 2>/dev/null
    iptables -D INPUT -p tcp --dport "$p" -s 100.64.0.0/10 -j ACCEPT 2>/dev/null
    iptables -D INPUT -p tcp --dport "$p" -j DROP 2>/dev/null
    echo "Cleaned iptables rules for $p"
}

PORT=$(grep -i '^port=' "$CONF" 2>/dev/null | cut -d'=' -f2 | tr -cd '0-9')
[ -z "$PORT" ] && PORT="$DEFAULT_PORT"

ALLOW_TAILNET_ONLY=$(grep -i '^allowTailnetOnly=' "$CONF" 2>/dev/null | cut -d'=' -f2 | tr -d ' \r\n' | tr '[:upper:]' '[:lower:]')
[ -z "$ALLOW_TAILNET_ONLY" ] && ALLOW_TAILNET_ONLY="false"

EXISTING_PORT=$(getprop service.adb.tcp.port)
[ "$EXISTING_PORT" != "$PORT" ] && cleanup "$EXISTING_PORT"

cleanup "$PORT"

setprop service.adb.tcp.port "${PORT}"

if [ "$ALLOW_TAILNET_ONLY" = "true" ]; then
    iptables -I INPUT 1 -p tcp --dport "$PORT" -m state --state RELATED,ESTABLISHED -j ACCEPT
    iptables -I INPUT 2 -p tcp --dport "$PORT" -s 100.64.0.0/10 -j ACCEPT
    iptables -I INPUT 3 -p tcp --dport "$PORT" -j DROP
    echo "Mode: Tailnet only"
else
    echo "Mode: All networks allowed"
fi

stop adbd
start adbd

echo "ADB restarted, port: $PORT"