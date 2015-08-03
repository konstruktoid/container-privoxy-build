# Force autobuild 1438639832

FROM alpine:3.2

RUN apk update && \
    apk upgrade && \
    apk --update add privoxy

COPY files/privoxy.config /etc/privoxy/config

EXPOSE 8118
ENTRYPOINT ["privoxy"]
CMD [""]
