#!/bin/bash
# Description: Script for alpine container
# Maintainer: Mauro Cardillo
# Default values of arguments
DOCKER_IMAGE=maurosoft1973/alpine-postfix-relay
DOCKER_IMAGE_TAG=latest
CONTAINER=alpine-postfix-relay-${DOCKER_IMAGE_TAG}
LC_ALL=it_IT.UTF-8
TIMEZONE=Europe/Rome

set +a
source ./.env.container

# Loop through arguments and process them
for arg in "$@"
do
    case $arg in
        -it=*|--image-tag=*)
        DOCKER_IMAGE_TAG="${arg#*=}"
        shift # Remove
        ;;
        -cn=*|--container=*)
        CONTAINER="${arg#*=}"
        shift # Remove
        ;;
        -cl=*|--lc_all=*)
        LC_ALL="${arg#*=}"
        shift # Remove
        ;;
        -ct=*|--timezone=*)
        TIMEZONE="${arg#*=}"
        shift # Remove
        ;;
        -h|--help)
        echo -e "usage "
        echo -e "$0 "
        echo -e "  -it=|--image-tag -> ${DOCKER_IMAGE}:${DOCKER_IMAGE_TAG} (image with tag)"
        echo -e "  -cn=|--container -> ${CONTAINER} (container name)"
        echo -e "  -cl=|--lc_all    -> ${LC_ALL} (container locale)"
        echo -e "  -ct=|--timezone  -> ${TIMEZONE} (container timezone)"
        exit 0
        ;;
    esac
done

CONTAINER=alpine-postfix-relay-${DOCKER_IMAGE_TAG}

echo "# Docker Image                        : ${DOCKER_IMAGE}:${DOCKER_IMAGE_TAG}"
echo "# Container Name                      : ${CONTAINER}"
echo "# Container Locale                    : ${LC_ALL}"
echo "# Container Timezone                  : ${TIMEZONE}"
echo "# Container SMTP_RECIPIENT            : ${SMTP_RECIPIENT}"
echo "# Container SMTP_SENDER_NAME          : ${SMTP_SENDER_NAME}"
echo "# Container SMTP_HOST                 : ${SMTP_HOST}"
echo "# Container SMTP_PORT                 : ${SMTP_PORT}"
echo "# Container SMTP_LOGIN                : ${SMTP_LOGIN}"
echo "# Container SMTP_PASSWORD             : ${SMTP_PASSWORD}"
echo "# Container SMTP_DEBUG_PEER_LIST      : ${SMTP_DEBUG_PEER_LIST}"
echo "# Container ACCEPTED_NETWORKS         : ${ACCEPTED_NETWORKS}"
echo "# Container RECIPIENT_RESTRICTIONS    : ${RECIPIENT_RESTRICTIONS}"
echo "# Container SMTP_USE_TLS              : ${SMTP_USE_TLS}"
echo "# Container SMTP_TLS_SECURITY_LEVEL   : ${SMTP_TLS_SECURITY_LEVEL}"
echo "# Container SMTPD_TLS_SECURITY_LEVEL  : ${SMTP_USE_TLS}"

echo -e "Check if container ${CONTAINER} exist"
CHECK=$(docker container ps -a | grep ${CONTAINER} | wc -l)
if [ ${CHECK} == 1 ]; then
    echo -e "Stop Container -> ${CONTAINER}"
    docker stop ${CONTAINER} > /dev/null

    echo -e "Remove Container -> ${CONTAINER}"
    docker container rm ${CONTAINER} > /dev/null
else 
    echo -e "The container ${CONTAINER} not exist"
fi

echo -e "Create and run container"
docker run -dit -p ${IP_LISTEN}:25:25 -p ${IP_LISTEN}:587:587 \
       --name ${CONTAINER} \
       -e LC_ALL=${LC_ALL} \
       -e TIMEZONE=${TIMEZONE} \
       -e SMTP_SENDER_NAME="${SMTP_SENDER_NAME}" \
       -e SMTP_RELAY_HOST=${SMTP_HOST} \
       -e SMTP_RELAY_PORT=${SMTP_PORT} \
       -e SMTP_RELAY_LOGIN=${SMTP_LOGIN} \
       -e SMTP_RELAY_PASSWORD=${SMTP_PASSWORD} \
       -e ACCEPTED_NETWORKS="${ACCEPTED_NETWORKS}" \
       -e RECIPIENT_RESTRICTIONS="${RECIPIENT_RESTRICTIONS}" \
       -e SMTP_DEBUG_PEER_LIST=${SMTP_DEBUG_PEER_LIST} \
       -e SMTP_USE_TLS=${SMTP_USE_TLS} \
       -e SMTP_TLS_SECURITY_LEVEL=${SMTP_TLS_SECURITY_LEVEL} \
       -e SMTPD_TLS_SECURITY_LEVEL=${SMTPD_TLS_SECURITY_LEVEL} \
       ${DOCKER_IMAGE}:${DOCKER_IMAGE_TAG}

#-e ACCEPTED_NETWORKS=${ACCEPTED_NETWORKS} \

echo -e ""
echo -e "Sleep 5 second"
sleep 5

IP=$(docker exec -it ${CONTAINER} /sbin/ip route | grep "src" | awk '{print $7}')
echo -e "IP Address is: $IP"

echo -e ""
echo -e "Environment variable"
docker exec -it ${CONTAINER} env

echo -e ""
echo -e "Test Locale (date)"
docker exec -it ${CONTAINER} date

echo -e ""
#echo -e "Check Release Version"
#CONTAINER_ALPINE_VERSION_RAW=$(docker exec -it ${CONTAINER} cat /etc/alpine-release)
#CONTAINER_ALPINE_VERSION=`echo $CONTAINER_ALPINE_VERSION_RAW | sed 's/\\r//g'`

#echo -e "Container Version -> ${CONTAINER_ALPINE_VERSION}"
#echo -e "Expected Version  -> ${ALPINE_VERSION}"

#if [ "${CONTAINER_ALPINE_VERSION}" == "${ALPINE_VERSION}" ]; then
#    echo -e "OK"
#else 
#    echo -e "KO"
#fi

docker exec -it ${CONTAINER} cat /etc/postfix/main.cf
docker exec -it ${CONTAINER} cat /etc/postfix/master.cf
docker exec -it ${CONTAINER} cat /etc/postfix/header_check

# send email (with mail command)
echo "Test message from Linux server using mail" | mail -s "Test Message" mauro.cardillo@maurosoft.com

# send email with curl
cat <<EOF > mail.txt
From: ${SMTP_SENDER_NAME} <$SMTP_LOGIN>
To: Mario Rossi <${SMTP_RECIPIENT}>
Subject: Test Message - CURL

Dear Mauro,
Test message from Linux server using mail
EOF

curl smtp://localhost -v --mail-from "$SMTP_LOGIN" --mail-rcpt "$SMTP_RECIPIENT" -T "mail.txt"

rm mail.txt

watch docker container logs ${CONTAINER}

