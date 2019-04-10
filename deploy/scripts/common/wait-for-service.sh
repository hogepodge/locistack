#!/bin/bash
set -x

NAME="$1"
PORT="$2"

until $(curl --output /dev/null --silent --fail http://${CONTROL_HOST_IP}:${PORT}); do
    printf "Waiting on $NAME"
    sleep 5
done
