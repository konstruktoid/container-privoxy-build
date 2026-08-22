FROM konstruktoid/alpine:latest@sha256:3f47343c0873bce996c9bd6d336b44e41faa77b86558a90e213eb8da644199de

LABEL org.opencontainers.image.title="privoxy" \
      org.opencontainers.image.description="Privoxy, a non-caching web proxy with filtering capabilities" \
      org.opencontainers.image.authors="Thomas Sjögren <konstruktoid@users.noreply.github.com>" \
      org.opencontainers.image.source="https://github.com/konstruktoid/container-privoxy-build" \
      org.opencontainers.image.url="https://www.privoxy.org/" \
      org.opencontainers.image.base.name="docker.io/konstruktoid/alpine"

COPY files/ /etc/privoxy/

# --no-cache leaves no index behind, so there is no /var/cache/apk to remove.
# The packages are deliberately unpinned: the image exists to carry the newest
# patched package set. See "Reproducibility" in README.md.
# hadolint ignore=DL3018
RUN apk --no-cache add curl privoxy && \
    mkdir -p /var/log/privoxy && \
    chown -R privoxy:privoxy /etc/privoxy /var/log/privoxy && \
    chmod 0750 /etc/privoxy /var/log/privoxy

HEALTHCHECK --interval=1m --timeout=3s --start-period=15s \
  CMD ["curl", "--fail", "--silent", "--show-error", "--proxy", "127.0.0.1:8118", "http://p.p/"]

EXPOSE 8118

# privoxy, uid 100 and gid 101, created by the Alpine privoxy package.
USER privoxy

# privoxy takes the config file as a positional argument. The previous CMD [""]
# passed an empty string, which privoxy tried to open as a config file.
ENTRYPOINT ["/usr/sbin/privoxy"]
CMD ["--no-daemon", "/etc/privoxy/config"]
