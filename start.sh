#!/bin/bash

sudo service docker start

####################
###   Binaries   ###
####################
DOCKER=$(which docker)
####################

PROJECT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"

export USER_ID=${UID}
export GROUP_ID=${UID}

${DOCKER} stop $(${DOCKER} ps -a -q) && ${DOCKER} rm $(${DOCKER} ps -a -q) --volumes

${DOCKER} \
    run -d --name movies-api -p 80:3000 -e MONGO_URL=10.10.10.10 -e MONGO_DATABASE=movies \
    geekshubsdevops/movies-api:latest