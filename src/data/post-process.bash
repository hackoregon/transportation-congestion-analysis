#! /bin/bash

# define parameters
export filedates=("1-30SEP2017" "1-31OCT2017" "1-30NOV2017")
export tabledates=("ended_20170930" "ended_20171031" "ended_20171130")
export tablenames=("init_cyclic_v1h" "init_veh_stoph" "trimet_stop_event" "init_tripsh")
export raw="../../data/raw"
export interim="../../data/interim"
export PGDATABASE=trimet_congestion

for datex in 0 1 2
do
  filedate=${filedates[$datex]}
  tabledate=${tabledates[$datex]}
  for tablex in 0 1 2 3
  do
    tablename="${tablenames[$tablex]}"
    filename="${tablename} ${filedate}.csv"
    db_tablename="${tabledate}_${tablename}"
    echo "file: $filename => table: $db_tablename"

    # run the post-processing
    echo "pkey processing"
    sed "s;ENDDATE;${tabledate};" ${tablename}.pkey | /usr/bin/time psql
    echo "timestamp processing"
    sed "s;ENDDATE;${tabledate};" ${tablename}.timestamp | /usr/bin/time psql
    echo "geom processing"
    sed "s;ENDDATE;${tabledate};" ${tablename}.geom | /usr/bin/time psql
    psql -c "VACUUM ANALYZE ${db_tablename};"

  done
done
