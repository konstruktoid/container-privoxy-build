# Force autobuild 1437957740

FROM alpine:3.1

RUN apk update && \
    apk upgrade && \
    apk --update add privoxy

COPY files/privoxy.config /etc/privoxy/config

EXPOSE 8118
ENTRYPOINT ["privoxy"]
CMD [""]
