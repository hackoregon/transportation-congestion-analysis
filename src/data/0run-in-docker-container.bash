#! /bin/bash

echo "Building the image"
docker build --tag postgis:latest .
docker images
echo "Force-removing existing containers"
docker rm -f `docker ps -aq`
echo "Running the container"
docker run --detach --rm --name=postgisc --volume /csvs:/csvs postgis
docker ps
echo "Copying the scripts"
docker cp . postgisc:/src
docker exec --user=root postgisc chown -R postgres:postgres /src
echo "Chowning the input CSVs"
docker exec --user=root postgisc chown -R postgres:postgres /csvs
echo "Loading the database"
docker exec --user=postgres --workdir=/src postgisc /src/2load.bash
echo "Backing up the database"
docker exec --user=postgres --workdir=/src postgisc /src/9create-database-backup.bash
echo "Retrieving the backup"
docker cp postgisc:/csvs/transit_operations_analytics_data.backup .
docker cp postgisc:/csvs/transit_operations_analytics_data.backup.sha512sum .
sha512sum -c transit_operations_analytics_data.backup.sha512sum
