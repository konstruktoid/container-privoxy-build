FROM konstruktoid/alpine

RUN apk update && \
    apk upgrade && \
    apk --update add privoxy

COPY files/privoxy.config /etc/privoxy/config

RUN chown privoxy:privoxy /etc/privoxy/config

EXPOSE 8118
ENTRYPOINT ["/usr/sbin/privoxy"]
CMD [""]
