#!/usr/bin/env bash

if [[ ! -f .env ]]; then
    echo "Error: Cannot find environment file .env, run the setup.sh script"
    exit 1
fi

source .env
docker stack deploy -c ./docker-compose.yml -c ./docker-compose-swarm.yml "${@}"
