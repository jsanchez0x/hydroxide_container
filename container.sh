#!/bin/bash
DOCKER_IMAGE="jsanchez0x/hydroxide"
DOCKER_TAG="local"
DOCKER_CONTAINER_NAME="hydroxide"

if [ "$1" == "build" ]; then
    docker build --rm --tag ${DOCKER_IMAGE}:${DOCKER_TAG} .

elif [ "$1" == "run" ]; then
    docker run -d -it \
        -p 1025:1025/tcp \
        -p 1143:1143/tcp \
        -p 8088:8088/tcp \
        -v $(pwd)/docker-volume-data:/root/.config/hydroxide \
        --restart=unless-stopped \
        --name ${DOCKER_CONTAINER_NAME} \
        ${DOCKER_IMAGE}:${DOCKER_TAG}

elif [ "$1" == "shell" ]; then
    docker exec -it ${DOCKER_CONTAINER_NAME} sh

elif [ "$1" == "carddav" ] || [ "$1" == "imap" ] || [ "$1" == "smtp" ] || [ "$1" == "serve" ]; then
    docker exec -it ${DOCKER_CONTAINER_NAME} hydroxide -smtp-host 0.0.0.0 -imap-host 0.0.0.0 -carddav-host 0.0.0.0 $1

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
    echo "    cardav/imap/smtp/serve      Manual run servers in hydroxide."
    echo "    status                      Get current loged users."
    echo "    auth                        Add account to hydroxide."
fi