#!/bin/bash
###
# @Author: Ray zai7lou@outlook.com
# @Date: 2024-07-12 22:00:19
# @LastEditors: Ray zai7lou@outlook.com
# @LastEditTime: 2024-07-13 14:15:04
# @FilePath: \sing-box-installer\sing-box\data\entry.sh
# @Description:
#
# Copyright (c) 2024 by ${git_name_email}, All Rights Reserved.
###
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
# PORT_TLS_HTTP_CHALLENGE is used for issue TLS
PORT_TLS_HTTP_CHALLENGE="${PORT_TLS_HTTP_CHALLENGE:=20440}"

# Update configuration with environment variables
sed -i \
    -e "s/\"\$PORT_TROJAN\"/$PORT_TROJAN/g" \
    -e "s/\"\$PORT_VLESS\"/$PORT_VLESS/g" \
    -e "s/\"\$PORT_VMESS\"/$PORT_VMESS/g" \
    -e "s/\"\$PORT_HYSTERIA\"/$PORT_HYSTERIA/g" \
    -e "s/\"\$PORT_TUIC\"/$PORT_TUIC/g" \
    -e "s/\"\$PORT_TLS_HTTP_CHALLENGE\"/$PORT_TLS_HTTP_CHALLENGE/g" \
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
cat "$configFilePath"

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
