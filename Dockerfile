FROM ghcr.io/sagernet/sing-box

COPY config.json /etc/sing-box/config.json
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
