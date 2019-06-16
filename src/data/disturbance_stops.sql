\echo creating disturbance_stops table
SET timezone = 'PST8PDT';
DROP TABLE IF EXISTS disturbance_stops CASCADE;
CREATE TABLE disturbance_stops (
  opd_date date not null,
  service_key text,
  year integer,
  month integer,
  day integer,
  day_of_week integer,
  act_arr_time timestamp with time zone,
  act_dep_time timestamp with time zone,
  start_quarter_hour real,
  end_quarter_hour real,
  duration interval,
  line_id integer,
  pattern_direction text,
  gps_longitude double precision,
  gps_latitude double precision,
  geom_point_4326 geometry,
  id serial
) PARTITION BY RANGE(opd_date) ;

CREATE TABLE disturbance_stops_y2017m09
PARTITION OF disturbance_stops
FOR VALUES FROM ('2017-09-01') TO ('2017-10-01');

CREATE TABLE disturbance_stops_y2017m10
PARTITION OF disturbance_stops
FOR VALUES FROM ('2017-10-01') TO ('2017-11-01');

CREATE TABLE disturbance_stops_y2017m11
PARTITION OF disturbance_stops
FOR VALUES FROM ('2017-11-01') TO ('2017-12-01');

CREATE TABLE disturbance_stops_y2018m09
PARTITION OF disturbance_stops
FOR VALUES FROM ('2018-09-01') TO ('2018-10-01');

CREATE TABLE disturbance_stops_y2018m10
PARTITION OF disturbance_stops
FOR VALUES FROM ('2018-10-01') TO ('2018-11-01');

CREATE TABLE disturbance_stops_y2018m11
PARTITION OF disturbance_stops
FOR VALUES FROM ('2018-11-01') TO ('2018-12-01');

CREATE INDEX ON disturbance_stops (opd_date);
CREATE INDEX ON disturbance_stops (line_id, pattern_direction);
CREATE INDEX ON disturbance_stops (year);
CREATE INDEX ON disturbance_stops (month);
CREATE INDEX ON disturbance_stops (day_of_week);
CREATE INDEX ON disturbance_stops (start_quarter_hour, end_quarter_hour);

\echo loading
INSERT INTO disturbance_stops
SELECT opd_date, service_key, year, month, day, day_of_week, act_arr_time, act_dep_time,
  0.25 * trunc(4 * date_part('hour', act_arr_time) +
    date_part('minute', act_arr_time) / 15) AS start_quarter_hour,
  0.25 * trunc(4 * date_part('hour', act_dep_time) +
    date_part('minute', act_dep_time) / 15) AS end_quarter_hour,
  act_dep_time - act_arr_time AS duration,
  line_id, pattern_direction,
  gps_longitude, gps_latitude, ST_SetSRID(ST_MakePoint(gps_longitude, gps_latitude), 4326) AS geom_point_4326
FROM bus_all_stops
INNER JOIN bus_service_keys ON bus_all_stops.opd_date = bus_service_keys.service_date
WHERE stop_type = 3;
\echo primary key
ALTER TABLE disturbance_stops ADD PRIMARY KEY (opd_date, id);
\echo register geometry column
SELECT UpdateGeometrySRID('public', 'disturbance_stops', 'geom_point_4326', 4326);