ARG DOCKER_ALPINE_VERSION

FROM maurosoft1973/alpine:$DOCKER_ALPINE_VERSION

ARG BUILD_DATE
ARG ALPINE_ARCHITECTURE
ARG ALPINE_RELEASE
ARG ALPINE_VERSION
ARG ALPINE_VERSION_DATE
ARG POSTFIX_VERSION
ARG POSTFIX_VERSION_DATE

LABEL \
    maintainer="Mauro Cardillo <mauro.cardillo@gmail.com>" \
    architecture="$ALPINE_ARCHITECTURE" \
    postfix-version="$POSTFIX_VERSION" \
    alpine-version="$ALPINE_VERSION" \
    build="$BUILD_DATE" \
    org.opencontainers.image.title="alpine-postfix-relay" \
    org.opencontainers.image.description="Postfix $POSTFIX_VERSION Relay Docker image running on Alpine Linux" \
    org.opencontainers.image.authors="Mauro Cardillo <mauro.cardillo@gmail.com>" \
    org.opencontainers.image.vendor="Mauro Cardillo" \
    org.opencontainers.image.version="v$POSTFIX_VERSION" \
    org.opencontainers.image.url="https://hub.docker.com/r/maurosoft1973/alpine-postfix-relay/" \
    org.opencontainers.image.source="https://gitlab.com/maurosoft1973-docker/alpine-postfix-relay" \
    org.opencontainers.image.created=$BUILD_DATE

RUN \
    echo "" > /etc/apk/repositories && \
    echo "https://dl-cdn.alpinelinux.org/alpine/v$ALPINE_RELEASE/main" >> /etc/apk/repositories && \
    echo "https://dl-cdn.alpinelinux.org/alpine/v$ALPINE_RELEASE/community" >> /etc/apk/repositories && \
    apk update && \
    apk add --update --no-cache \
    openssl \
    gettext \
    postfix \
    postfix-pcre \
    ca-certificates \
    cyrus-sasl \
    cyrus-sasl-login && cp /usr/bin/envsubst /usr/local/bin/

COPY conf/ /root/conf
COPY files/ /scripts
RUN chmod +x /scripts/run-alpine-postfix-relay.sh

EXPOSE 25 587

ENTRYPOINT ["/scripts/run-alpine-postfix-relay.sh"]