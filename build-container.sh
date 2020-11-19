#!/bin/bash
# Description: Script for Test. Read the value from .env local file
# Maintainer: Mauro Cardillo
#
set -a

# Read Value from Env File
[ ! -f ./.env ] && echo "File env not found" && exit 0

source ./.env

#SMTP_HOST=
#SMTP_PORT=
#SMTP_LOGIN=
#SMTP_PASSWORD=
#SMTP_DEBUG=
#ACCEPTED_NETWORKS=
#USE_TLS=
#TLS_VERIFY=
#RECIPIENT_TEST

# Loop through arguments and process them
for arg in "$@"
do
    case $arg in
        -c=*|--container=*)
        CONTAINER="${arg#*=}"
        shift # Remove
        ;;
        -l=*|--lc_all=*)
        LC_ALL="${arg#*=}"
        shift # Remove
        ;;
        -t=*|--timezone=*)
        TIMEZONE="${arg#*=}"
        shift # Remove
        ;;
        -h|--help)
        echo -e "usage "
        echo -e "$0 "
        echo -e "  -c=|--container=${CONTAINER} -> name of container"
        echo -e "  -l=|--lc_all=${LC_ALL} -> locale"
        echo -e "  -t=|--timezone=${TIMEZONE} -> timezone"
        exit 0
        ;;
    esac
done

echo "# Image               : ${IMAGE}"
echo "# Container Name      : ${CONTAINER}"
echo "# Locale              : ${LC_ALL}"
echo "# Timezone            : ${TIMEZONE}"

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

docker pull ${IMAGE}

echo -e "Create and run container"
docker run -dit --name ${CONTAINER} -p ${IP_LISTEN}:${PORT_LISTEN}:25 -e LC_ALL=${LC_ALL} -e TIMEZONE=${TIMEZONE} -e SMTP_HOST=${SMTP_HOST} -e SMTP_PORT=${SMTP_PORT} -e SMTP_LOGIN=${SMTP_LOGIN} -e SMTP_PASSWORD=${SMTP_PASSWORD} -e SMTP_DEBUG=${SMTP_DEBUG} -e ACCEPTED_NETWORKS=${ACCEPTED_NETWORKS} ${IMAGE}

echo -e "Sleep 5 second"
sleep 5

IP=$(docker exec -it ${CONTAINER} /sbin/ip route | grep "src" | awk '{print $7}')
echo -e "IP Address is: $IP";

echo -e ""
echo -e "Environment variable";
docker exec -it ${CONTAINER} env

echo -e ""
echo -e "Test Send Email"
swaks --from ${SMTP_LOGIN} --to ${RECIPIENT_TEST} --server ${IP}:${PORT_LISTEN} --header "Subject: Test send email with docker" --body "Email sent with docker"

echo -e ""
echo -e "Container Logs"
docker logs ${CONTAINER}
