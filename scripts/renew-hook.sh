#!/bin/sh
DOMAIN=vitaback.coolycow.com

cat ./certs/live/$DOMAIN/fullchain.pem ./certs/live/$DOMAIN/privkey.pem > ./docker/unit/$DOMAIN.pem