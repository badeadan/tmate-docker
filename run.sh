#!/bin/bash
docker container stop tmate-docker
docker container rm tmate-docker
docker run \
    --privileged \
    -e HOST=1.1.1.1 \
    -e PORT=22 \
    -p 2022:22 \
    --name tmate-docker \
    -d tmate-docker
