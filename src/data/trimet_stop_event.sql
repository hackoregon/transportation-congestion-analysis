\echo creating trimet stop event
SET search_path TO trimet_stop_event, public;
DROP TABLE IF EXISTS :trimet_stop_event;
CREATE TABLE :trimet_stop_event
(
  service_date text,
  vehicle_number integer,
  leave_time integer,
  train integer,
  badge integer,
  route_number integer,
  direction integer,
  service_key text,
  trip_number integer,
  stop_time integer,
  arrive_time integer,
  dwell integer,
  location_id integer,
  door integer,
  lift integer,
  ons integer,
  offs integer,
  estimated_load integer,
  maximum_speed integer,
  train_mileage real,
  pattern_distance real,
  location_distance real,
  x_coordinate real,
  y_coordinate real,
  data_source integer,
  schedule_status integer
);
COPY :trimet_stop_event FROM :trimet_stop_event_csv WITH csv header;
