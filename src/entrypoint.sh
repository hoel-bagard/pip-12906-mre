#!/usr/bin/env bash

if [ ! -d "/data/devpi-server" ]; then
    devpi-init --serverdir /data/devpi-server --root-passwd PYPI_PASSWORD
fi

service nginx restart
nginx

devpi-server --host=0.0.0.0 --port 3141 --serverdir /data/devpi-server --restrict-modify root
