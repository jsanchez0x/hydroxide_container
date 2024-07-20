#!/bin/bash
DOCKER_IMAGE="jsanchez0x/hydroxide"
DOCKER_TAG="local"
DOCKER_CONTAINER_NAME="hydroxide"
DOCKER_VOLUME=""
PUBLIC_HOST=""
LETSENCRYPT_EMAIL=""
CERTS_PATH=""


if [ "$1" == "build" ]; then
    docker build --rm --tag ${DOCKER_IMAGE}:${DOCKER_TAG} .

elif [ "$1" == "run" ]; then
    docker run -d -it \
        -p 587:587/tcp \
        -p 993:993/tcp \
        -p 8088:8088/tcp \
        --net proxy-network \
        -v ${DOCKER_VOLUME}/data:/root/.config/hydroxide \
        -v ${DOCKER_VOLUME}/lighttpd:/var/log/lighttpd \
        -v ${CERTS_PATH}:/root/.config/hydroxide/certs \
        --env "VIRTUAL_HOST=${PUBLIC_HOST}" \
        --env "VIRTUAL_PORT=80" \
        --env "LETSENCRYPT_HOST=${PUBLIC_HOST}" \
        --env "LETSENCRYPT_EMAIL=${LETSENCRYPT_EMAIL}" \
        --restart=unless-stopped \
        --name ${DOCKER_CONTAINER_NAME} \
        ${DOCKER_IMAGE}:${DOCKER_TAG}

elif [ "$1" == "shell" ]; then
    docker exec -it ${DOCKER_CONTAINER_NAME} sh

elif [ "$1" == "status" ] ; then
    docker exec -it ${DOCKER_CONTAINER_NAME} hydroxide $1

elif [ "$1" == "auth" ]; then
    echo "Proton user (user@proton.me):"
    read user
    docker exec -it ${DOCKER_CONTAINER_NAME} hydroxide $1 $user

else
    echo "Helper for run commands in the container."
    echo "PARAMETERS:"
    echo "    build                       Create the Docker image."
    echo "    run                         Run the Docker container."
    echo "    shell                       SH prompt to container."
    echo "    status                      Get current loged users."
    echo "    auth                        Add account to hydroxide."
fi