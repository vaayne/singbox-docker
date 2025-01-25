# Sing-Box Docker Configuration

A Docker-based configuration for running multiple proxy protocols using [sing-box](https://sing-box.sagernet.org/), including Trojan, VLESS, VMess, Hysteria2, and TUIC.

## Features

- Multiple protocol support:
  - Trojan
  - VLESS (with XTLS Vision)
  - VMess (WebSocket)
  - Hysteria2
  - TUIC
- Automatic TLS certificate management with ACME
- DNS over TLS configuration
- BBR congestion control for TUIC
- Caching support
- Docker containerization

## Prerequisites

- Docker
- A domain name
- Port forwarding configured on your server for the following ports:
  - 20441 (Trojan)
  - 20442 (VLESS)
  - 20443 (VMess)
  - 20444 (Hysteria2)
  - 20445 (TUIC)

## Environment Variables

The following environment variables need to be set:

- `DOMAIN`: Your domain name
- `EMAIL`: Email address for ACME certificate registration
- `UUID`: UUID for VLESS, VMess, and Hysteria2
- `USERNAME`: Username for Trojan
- `PASSWORD`: Password for Trojan and TUIC

Optional port configuration:
- `PORT_TROJAN`: Trojan port (default: 20441)
- `PORT_VLESS`: VLESS port (default: 20442)
- `PORT_VMESS`: VMess port (default: 20443)
- `PORT_HYSTERIA`: Hysteria2 port (default: 20444)
- `PORT_TUIC`: TUIC port (default: 20445)
- `NOHUP`: Set to "true" to run in background mode

## Quick Start

1. Clone this repository:
```bash
git clone https://github.com/vaayne/singbox-docker.git
cd singbox-docker
```

2. Set up environment variables:
```bash
export DOMAIN="your-domain.com"
export EMAIL="your-email@example.com"
export UUID="your-uuid"
export USERNAME="your-username"
export PASSWORD="your-password"
```

3. Build and run the Docker container:
```bash
docker build -t singbox .
docker run -d \
  -p 20441:20441 \
  -p 20442:20442 \
  -p 20443:20443 \
  -p 20444:20444 \
  -p 20445:20445 \
  -e DOMAIN=$DOMAIN \
  -e EMAIL=$EMAIL \
  -e UUID=$UUID \
  -e USERNAME=$USERNAME \
  -e PASSWORD=$PASSWORD \
  singbox
```

## Configuration Details

The configuration includes:

- DNS servers: Cloudflare (1.1.1.1) and Google (8.8.8.8) over TLS
- TLS enabled for all protocols
- Automatic certificate management using ACME
- WebSocket transport for VMess
- BBR congestion control for TUIC
- Cache file enabled for better performance


## License

This project is open source and available under the MIT License.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Disclaimer

This configuration is provided as-is. Please ensure you comply with local laws and regulations when using proxy services.
