#!/bin/bash
#
# pull code from repo, rebuild and restart container
# second part of a deploy script running in container (deploy.sh)
#
WORKDIR=$PWD/app
cd $WORKDIR
git switch dev
git restore .
git pull
git status
cd ..
#docker-compose up -d --build --remove-orphans --force-recreate web
docker-compose up -d --build --remove-orphans web
docker exec ff_dev_web /var/www/html/deploy.sh
