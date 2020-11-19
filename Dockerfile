FROM maurosoft1973/alpine

ARG BUILD_DATE

LABEL maintainer="Mauro Cardillo <mauro.cardillo@gmail.com>" \
    architecture="amd64/x86_64" \
    alpine-version="3.12.0" \
    build="$BUILD_DATE" \
    org.opencontainers.image.title="alpine" \
    org.opencontainers.image.description="Docker Postfix Relay image running on Alpine Linux" \
    org.opencontainers.image.authors="Mauro Cardillo <mauro.cardillo@gmail.com>" \
    org.opencontainers.image.vendor="Mauro Cardillo" \
    org.opencontainers.image.version="v3.12.0" \
    org.opencontainers.image.url="https://hub.docker.com/r/maurosoft1973/alpine/" \
    org.opencontainers.image.source="https://gitlab.com/maurosoft1973-docker/alpine" \
    org.opencontainers.image.created=$BUILD_DATE

RUN \
    apk add --update --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    gettext \
    postfix \
    postfix-pcre \
    cyrus-sasl-plain \
    cyrus-sasl-login && cp /usr/bin/envsubst /usr/local/bin/

COPY conf/ /root/conf
COPY files/ /scripts
RUN chmod +x /scripts/run-alpine-postfix-relay.sh

EXPOSE 25

ENTRYPOINT ["/scripts/run-alpine-postfix-relay.sh"]