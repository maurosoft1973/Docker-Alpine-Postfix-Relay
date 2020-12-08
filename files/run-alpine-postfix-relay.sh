#!/bin/sh
set -e # exit on error
source /scripts/init-alpine.sh

# Variables
[ -z "$SMTP_LOGIN" -o -z "$SMTP_PASSWORD" ] && {
	echo "SMTP_LOGIN and SMTP_PASSWORD _must_ be defined" >&2
	exit 1
}

if [ -n "$RECIPIENT_RESTRICTIONS" ]; then
	RECIPIENT_RESTRICTIONS="inline:{$(echo $RECIPIENT_RESTRICTIONS | sed 's/\s\+/=OK, /g')=OK}"
else
	RECIPIENT_RESTRICTIONS=static:OK
fi

if [ -n "$SMTP_DEBUG" ]; then
	SMTP_DEBUG_VERBOSE=3
else
	SMTP_DEBUG=0.0.0.0
	SMTP_DEBUG_VERBOSE=1
fi

TLS_WRAPPERMODE=no

if [ "${SMTP_PORT}" == "465" ]; then
	TLS_WRAPPERMODE=yes
	TLS_VERIFY=encrypt
fi

export SMTP_LOGIN SMTP_PASSWORD RECIPIENT_RESTRICTIONS SMTP_DEBUG SMTP_DEBUG_VERBOSE
export SMTP_HOST=${SMTP_HOST:-"smtp.example.com"}
export SMTP_PORT=${SMTP_PORT:-"25"}
export ACCEPTED_NETWORKS=${ACCEPTED_NETWORKS:-"192.168.0.0/16 172.16.0.0/12 10.0.0.0/8"}
export USE_TLS=${USE_TLS:-"no"}
export TLS_VERIFY=${TLS_VERIFY:-"may"}
export TLS_WRAPPERMODE

# Template
export DOLLAR='$'
envsubst < /root/conf/postfix-main.cf > /etc/postfix/main.cf

# Generate default alias DB
newaliases

postfix start-fg