#!/bin/bash
set -e
set -u
set -o pipefail

configFilePath="/etc/sing-box/config.json"
logFilePath="/tmp/sing-box.log"

# Environment variables with default values for ports
PORT_TROJAN="${PORT_TROJAN:=20441}"
PORT_VLESS="${PORT_VLESS:=20442}"
PORT_VMESS="${PORT_VMESS:=20443}"
PORT_HYSTERIA="${PORT_HYSTERIA:=20444}"
PORT_TUIC="${PORT_TUIC:=20445}"
PORT_TUIC_PROXY="${PORT_TUIC_PROXY:=20446}"
PORT_MIXED="${PORT_MIXED:=20447}"
SOCKS_SERVER="${SOCKS_SERVER:=192.168.1.1}"

# Update configuration with environment variables
sed -i \
    -e "s/\"\$PORT_TROJAN\"/$PORT_TROJAN/g" \
    -e "s/\"\$PORT_VLESS\"/$PORT_VLESS/g" \
    -e "s/\"\$PORT_VMESS\"/$PORT_VMESS/g" \
    -e "s/\"\$PORT_HYSTERIA\"/$PORT_HYSTERIA/g" \
    -e "s/\"\$PORT_TUIC\"/$PORT_TUIC/g" \
    -e "s/\"\$PORT_TUIC_PROXY\"/$PORT_TUIC_PROXY/g" \
    -e "s/\"\$PORT_MIXED\"/$PORT_MIXED/g" \
    -e "s/\$SOCKS_SERVER/$SOCKS_SERVER/g" \
    -e "s/\$CF_TOKEN/$CF_TOKEN/g" \
    -e "s/\$DOMAIN/$DOMAIN/g" \
    -e "s/\$EMAIL/$EMAIL/g" \
    -e "s/\$UUID/$UUID/g" \
    -e "s/\$USERNAME/$USERNAME/g" \
    -e "s/\$PASSWORD/$PASSWORD/g" \
    "$configFilePath"

echo "entry"
sing-box version

# https://sing-box.sagernet.org/configuration/
echo -e "\nconfig:"
sing-box check -c "$configFilePath" || cat "$configFilePath"
sing-box format -c "$configFilePath" -w
# cat "$configFilePath"

echo -e "\nstarting"
touch "$logFilePath"

if [ "${NOHUP:-false}" == "true" ]; then
    echo "running with nohup"
    nohup sing-box run -c "$configFilePath" &
    sleep 5s
    cat "$logFilePath"
else
    sing-box run -c "$configFilePath" 2>&1 | tee -a "$logFilePath"
fi
