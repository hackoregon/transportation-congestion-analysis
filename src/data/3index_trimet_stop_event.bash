#! /bin/bash

# define parameters
export DBOWNER=postgres
export PGDATABASE=transit_operations_analytics_data
export PGPORT=5440

# loop over month codes
for month in y2017_m09 y2017_m10 y2017_m11
do
  /usr/bin/time psql -U ${DBOWNER} -d ${PGDATABASE} -f index_trimet_stop_event.sql \
 -v trimet_stop_event=${month}_trimet_stop_event
done
