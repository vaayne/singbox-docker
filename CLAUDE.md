# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Docker-based sing-box proxy server configuration that provides multiple proxy protocols (Trojan, VLESS, VMess, Hysteria2, TUIC) with automatic TLS certificate management via ACME.

## Commands

### Running the Service

```bash
# Using Docker Compose (preferred)
docker-compose up -d
docker-compose logs -f
docker-compose down

# Direct Docker run
docker run -d \
  --network host \
  -e DOMAIN=$DOMAIN \
  -e EMAIL=$EMAIL \
  -e UUID=$UUID \
  -e USERNAME=$USERNAME \
  -e PASSWORD=$PASSWORD \
  -e CF_TOKEN=$CF_TOKEN \
  -v singbox-tls:/tls \
  ghcr.io/vaayne/singbox-docker:latest
```

### Required Environment Variables
- `DOMAIN`: Server domain for TLS certificates
- `EMAIL`: Email for ACME certificate registration
- `UUID`: UUID for VLESS/VMess protocols
- `USERNAME`: Username for Trojan protocol
- `PASSWORD`: Password for Trojan/Hysteria2/TUIC protocols
- `CF_TOKEN`: Cloudflare API token for DNS-01 challenge

### Optional Environment Variables
- `TROJAN_PORT` (default: 20441)
- `VLESS_PORT` (default: 20442)
- `VMESS_PORT` (default: 20443)
- `HYSTERIA2_PORT` (default: 20444)
- `TUIC_PORT` (default: 20445)
- `MIXED_PORT` (default: 20447)
- `NOHUP` (default: false) - Run in background mode

## Architecture

### Key Files
- `config.json`: Main sing-box configuration with environment variable placeholders
- `entrypoint.sh`: Replaces placeholders at runtime and validates configuration
- `docker-compose.yaml`: Service definition with all required environment variables

### Configuration Flow
1. `entrypoint.sh` replaces `${VAR}` placeholders in `config.json` with actual environment values
2. Configuration is validated using `sing-box check`
3. Sing-box service starts with the processed configuration

### Protocol Ports
- 20441: Trojan (TLS with fallback)
- 20442: VLESS (XTLS Vision)
- 20443: VMess (WebSocket)
- 20444: Hysteria2 (QUIC)
- 20445: TUIC (QUIC)
- 20446: TUIC Proxy (routes through mixed)
- 20447: Mixed (HTTP/SOCKS)

### TLS Certificate Management
- Uses ACME with Cloudflare DNS-01 challenge
- Certificates stored in `/tls` directory (volume mounted)
- Automatic renewal handled by sing-box

## Development Notes

When modifying configurations:
1. Always use environment variable placeholders in `config.json` (format: `${VAR_NAME}`)
2. Update `entrypoint.sh` if new variables need replacement
3. Test configuration validity with: `sing-box check -c config.json`
4. Remember that the container uses host network mode for optimal performance