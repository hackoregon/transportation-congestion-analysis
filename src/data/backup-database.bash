#! /bin/bash

# get connection details
source .env

# define parameters
export interim="../../data/interim"
export PGDATABASE=trimet_congestion
export JOBS=7 # one less than your processor / thread count - a four-core / eight-thread would use seven

echo "Removing previous backup directory if any"
rm -fr ${interim}/trimet_congestion.backup
echo "Making a backup"
pg_dump --format=directory --jobs=${JOBS} \
  --file=${interim}/trimet_congestion.backup ${PGDATABASE}
echo "How big is the backup?"
du -sh ${interim}/trimet_congestion.backup
pg_restore --list ${interim}/trimet_congestion.backup
