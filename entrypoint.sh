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
: "${PORT_TROJAN:=20441}"
: "${PORT_VLESS:=20442}"
: "${PORT_VMESS:=20443}"
: "${PORT_HYSTERIA:=20444}"
: "${PORT_TUIC:=20445}"

# Update configuration with environment variables
envsubst <"$configFilePath" >"$configFilePath.tmp" && mv "$configFilePath.tmp" "$configFilePath"

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
