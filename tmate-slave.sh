#!/bin/sh
cd /tmate-slave
if [ -n "${HOST}" ]; then
  hostopt="-h ${HOST}"
fi

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LD_LIBRARY_PATH=/usr/local/lib

./tmate-slave $hostopt -p ${PORT?2222} 2>&1
