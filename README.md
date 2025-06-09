# Sing-Box Docker

A production-ready Docker setup for [sing-box](https://sing-box.sagernet.org/) - a universal proxy platform supporting multiple protocols with automatic TLS certificate management.

## 🚀 Features

- **Multi-Protocol Support**
  - **Trojan** - TLS-based protocol with website fallback
  - **VLESS** - Lightweight protocol with XTLS Vision flow control
  - **VMess** - Versatile protocol with WebSocket transport
  - **Hysteria2** - QUIC-based protocol for unstable networks
  - **TUIC** - QUIC-based protocol with BBR congestion control
  - **Mixed** - HTTP/SOCKS proxy support

- **Security & Performance**
  - Automatic TLS certificate management via ACME (Cloudflare DNS-01)
  - DNS over TLS (DoT) with Cloudflare and Google
  - Built-in caching for improved performance
  - BBR congestion control optimization

- **Easy Deployment**
  - Single Docker image with all dependencies
  - Docker Compose support
  - Environment variable configuration
  - Automatic configuration validation

## 📋 Prerequisites

- Docker and Docker Compose installed
- A domain name pointing to your server
- Cloudflare account with API token (for DNS-01 challenge)
- Open ports: 20441-20447 (configurable)

## 🔧 Quick Start

### 1. Clone the repository

```bash
git clone https://github.com/yourusername/singbox-docker.git
cd singbox-docker
```

### 2. Configure environment variables

Create a `.env` file:

```bash
# Required variables
DOMAIN=your-domain.com
EMAIL=your-email@example.com
UUID=$(uuidgen)  # Generate a new UUID
USERNAME=your-username
PASSWORD=your-secure-password
CF_TOKEN=your-cloudflare-api-token

# Optional port configuration (defaults shown)
TROJAN_PORT=20441
VLESS_PORT=20442
VMESS_PORT=20443
HYSTERIA2_PORT=20444
TUIC_PORT=20445
TUIC_PROXY_PORT=20446
MIXED_PORT=20447

# Optional: Run in background mode
NOHUP=false
```

### 3. Start the service

Using Docker Compose (recommended):

```bash
docker-compose up -d
```

Or using Docker directly:

```bash
docker run -d \
  --name singbox \
  --network host \
  --restart unless-stopped \
  -v singbox-tls:/tls \
  -e DOMAIN=$DOMAIN \
  -e EMAIL=$EMAIL \
  -e UUID=$UUID \
  -e USERNAME=$USERNAME \
  -e PASSWORD=$PASSWORD \
  -e CF_TOKEN=$CF_TOKEN \
  ghcr.io/vaayne/singbox-docker:latest
```

### 4. Check logs

```bash
docker-compose logs -f
# or
docker logs -f singbox
```

## 📱 Client Configuration

### Protocol Details

| Protocol | Port | Authentication | Features |
|----------|------|----------------|----------|
| Trojan | 20441 | Username + Password | TLS with website fallback |
| VLESS | 20442 | UUID | XTLS Vision flow control |
| VMess | 20443 | UUID | WebSocket transport |
| Hysteria2 | 20444 | Password | QUIC, optimized for poor networks |
| TUIC | 20445 | UUID + Password | QUIC with BBR |
| Mixed | 20447 | None | HTTP/SOCKS proxy |

### Example Client Configurations

<details>
<summary>Trojan Configuration</summary>

```json
{
  "type": "trojan",
  "server": "your-domain.com",
  "server_port": 20441,
  "password": "your-username:your-password",
  "tls": {
    "enabled": true,
    "server_name": "your-domain.com"
  }
}
```
</details>

<details>
<summary>VLESS Configuration</summary>

```json
{
  "type": "vless",
  "server": "your-domain.com",
  "server_port": 20442,
  "uuid": "your-uuid",
  "flow": "xtls-rprx-vision",
  "tls": {
    "enabled": true,
    "server_name": "your-domain.com"
  }
}
```
</details>

<details>
<summary>VMess Configuration</summary>

```json
{
  "type": "vmess",
  "server": "your-domain.com",
  "server_port": 20443,
  "uuid": "your-uuid",
  "transport": {
    "type": "ws",
    "path": "/vmess"
  },
  "tls": {
    "enabled": true,
    "server_name": "your-domain.com"
  }
}
```
</details>

## 🛠️ Advanced Configuration

### Custom Ports

You can customize ports by setting environment variables:

```bash
export TROJAN_PORT=8443
export VLESS_PORT=8444
# ... etc
```

### Certificate Storage

TLS certificates are stored in a Docker volume named `singbox-tls`. To backup certificates:

```bash
docker run --rm -v singbox-tls:/tls -v $(pwd):/backup alpine tar czf /backup/tls-backup.tar.gz -C /tls .
```

### Configuration Validation

The entrypoint script automatically validates the configuration before starting. To manually validate:

```bash
docker run --rm -v $(pwd)/config.json:/etc/sing-box/config.json ghcr.io/vaayne/singbox-docker:latest sing-box check -c /etc/sing-box/config.json
```

## 📊 Monitoring

### View logs
```bash
docker-compose logs -f
```

### Check service status
```bash
docker-compose ps
```

### Monitor resource usage
```bash
docker stats singbox
```

## 🔧 Troubleshooting

### Common Issues

1. **Certificate generation fails**
   - Ensure your domain points to the server
   - Check Cloudflare API token permissions
   - Verify CF_TOKEN is set correctly

2. **Connection refused**
   - Check firewall rules
   - Verify ports are not in use: `netstat -tulpn | grep LISTEN`
   - Ensure Docker is using host network mode

3. **High CPU usage**
   - Normal during initial certificate generation
   - Check for DOS attacks if persistent

### Debug Mode

For detailed logs, modify docker-compose.yaml:

```yaml
command: ["sing-box", "run", "-c", "/etc/sing-box/config.json", "-D", "/var/log/sing-box"]
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⚠️ Disclaimer

This software is provided for educational and legitimate use only. Users are responsible for complying with local laws and regulations. The authors assume no liability for misuse of this software.