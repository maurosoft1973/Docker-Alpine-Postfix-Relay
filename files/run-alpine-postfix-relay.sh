#!/bin/sh
set -e # exit on error
export SMTP_SENDER_NAME=${SMTP_SENDER_NAME:-""}
export SMTP_RELAY_HOST=${SMTP_RELAY_HOST:-""}
export SMTP_RELAY_PORT=${SMTP_RELAY_PORT:-""}
export SMTP_RELAY_LOGIN=${SMTP_RELAY_LOGIN:-""}
export SMTP_RELAY_PASSWORD=${SMTP_RELAY_PASSWORD:-""}
export RECIPIENT_RESTRICTIONS=${RECIPIENT_RESTRICTIONS:-""}
export ACCEPTED_NETWORKS=${ACCEPTED_NETWORKS:-"192.168.0.0/16 172.17.0.0/16 172.16.0.0/12 10.0.0.0/8"}
export SMTP_USE_TLS=${SMTP_USE_TLS:-"no"}
export SMTP_TLS_SECURITY_LEVEL=${SMTP_TLS_SECURITY_LEVEL:-"may"}
export SMTP_TLS_WRAPPERMODE=no
export SMTPD_TLS_SECURITY_LEVEL=${SMTPD_TLS_SECURITY_LEVEL:-"none"}
export SMTP_DEBUG_PEER_LIST=${SMTP_DEBUG_PEER_LIST:-"0.0.0.0"}
export SMTP_DEBUG_PEER_LEVEL=${SMTP_DEBUG_PEER_LEVEL:-"3"}

source /scripts/init-alpine.sh

# generate cerficate
openssl req -newkey rsa:4096 -x509 -sha256 -days 3650 -nodes -out "/etc/ssl/certs/$HOSTNAME.pem" -keyout "/etc/ssl/certs/$HOSTNAME.key" -subj "/CN=$HOSTNAME"

# setup dns resolver
mkdir -p /var/spool/postfix/etc/
echo 'nameserver 8.8.8.8' >> /var/spool/postfix/etc/resolv.conf

# set timezone
mkdir -p /var/spool/postfix/etc
cp /etc/localtime /var/spool/postfix/etc/

# Variables
[ -z "${SMTP_RELAY_LOGIN}" -o -z "${SMTP_RELAY_PASSWORD}" ] && {
    echo "SMTP_RELAY_LOGIN and SMTP_RELAY_PASSWORD _must_ be defined" >&2
    exit 1
}

if [ -n "${RECIPIENT_RESTRICTIONS}" ]; then
    RECIPIENT_RESTRICTIONS="inline:{$(echo ${RECIPIENT_RESTRICTIONS} | sed 's/\s\+/=OK, /g')=OK}"
else
    RECIPIENT_RESTRICTIONS=static:OK
fi

SMTP_TLS_WRAPPERMODE=no

if [ "${SMTP_RELAY_PORT}" == "465" ]; then
    SMTP_TLS_WRAPPERMODE=yes
    SMTP_TLS_SECURITY_LEVEL=encrypt
fi

# Template
export DOLLAR='$'
envsubst < /root/conf/postfix-main.cf > /etc/postfix/main.cf
envsubst < /root/conf/postfix-master.cf > /etc/postfix/master.cf
envsubst < /root/conf/header_check > /etc/postfix/header_check

# Generate default alias DB
newaliases

postfix start-fg
