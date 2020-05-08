#!/bin/bash

#Clear old db files
echo 'Removing old files'
rm -rf redis_data
rm -rf mysql_data
rm -rf mongo_data

#Build Containers
echo 'Building Containers, might take a while'
docker-compose -f docker-compose.dev.yml build

# MYSQL does not play well with other containers if not allowed to finish config beforehand
echo 'Waiting for MYSQL to finish its thing....'
docker-compose -f docker-compose.dev.yml up -d db
echo 'Waiting for 1 Minute'
sleep 1m

echo 'Applying Database Migrations'
docker-compose -f docker-compose.dev.yml run --rm django /bin/sh migrations.sh

echo 'Starting All Containers'
docker-compose -f docker-compose.dev.yml up
