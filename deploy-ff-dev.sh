#!/bin/bash
#
# pull code from repo, rebuild and restart container
# second part of a deploy script running in container (deploy.sh)
#
cd app
git switch dev
git restore .
git pull
git status
cd ..
docker-compose up -d --build --remove-orphans --force-recreate web
docker exec -it ff_dev_web /var/www/html/deploy.sh
