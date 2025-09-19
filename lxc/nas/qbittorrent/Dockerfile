FROM alpine:3.22 AS downloader
ARG VERSION=release-5.1.2_v2.0.11
WORKDIR /root
RUN wget -qO qbittorrent-nox https://github.com/userdocs/qbittorrent-nox-static/releases/download/$VERSION/x86-qbittorrent-nox \
  && wget -qO dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.5/dumb-init_1.2.5_x86_64

FROM alpine:3.22
RUN set -x \
  # Add non-root group
  && addgroup -g 1000 -S qbittorrent \
  # Add non-root user
  && adduser -h /home/qbittorrent -S -u 1000 -s /usr/sbin/nologin -G qbittorrent qbittorrent \
  # Create symbolic links to simplify mounting
  && mkdir -p /home/qbittorrent/.config/qBittorrent \
  && chown qbittorrent:qbittorrent /home/qbittorrent/.config/qBittorrent \
  && ln -s /home/qbittorrent/.config/qBittorrent /config \
  \
  && mkdir -p /home/qbittorrent/.local/share/qBittorrent \
  && chown qbittorrent:qbittorrent /home/qbittorrent/.local/share/qBittorrent \
  && ln -s /home/qbittorrent/.local/share/qBittorrent /torrents \
  \
  && mkdir /downloads \
  && chown qbittorrent:qbittorrent /downloads

COPY --chmod=755 --from=downloader /root/qbittorrent-nox /bin/qbittorrent-nox
COPY --chmod=755 --from=downloader /root/dumb-init /bin/dumb-init

COPY --chown=qbittorrent:qbittorrent --chmod=755 ./entrypoint.sh /home/qbittorrent

VOLUME ["/config", "/torrents", "/downloads"]

ENV HOME=/home/qbittorrent
WORKDIR /home/qbittorrent

USER qbittorrent

EXPOSE 8080 6881

ENTRYPOINT ["dumb-init", "/home/qbittorrent/entrypoint.sh"]
CMD ["qbittorrent-nox"]

HEALTHCHECK --interval=5s --timeout=2s --retries=20 CMD curl --connect-timeout 15 --silent --show-error --fail http://localhost:8080/ >/dev/null || exit 1
