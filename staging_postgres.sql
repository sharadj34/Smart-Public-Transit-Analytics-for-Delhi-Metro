-- Drop if re-running
DROP TABLE IF EXISTS stg_stations;
DROP TABLE IF EXISTS stg_passengers;
DROP TABLE IF EXISTS stg_trips;
DROP TABLE IF EXISTS stg_revenue;

-- Staging tables mirror CSV columns (text where needed)
CREATE TABLE stg_stations (
  station_id   INTEGER,
  station_name TEXT,
  line_name    TEXT,
  zone         TEXT
);

CREATE TABLE stg_passengers (
  passenger_id INTEGER,
  age          INTEGER,
  gender       TEXT,
  card_type    TEXT
);

CREATE TABLE stg_trips (
  trip_id       INTEGER,
  passenger_id  INTEGER,
  entry_station INTEGER,
  exit_station  INTEGER,
  trip_datetime TEXT,       -- e.g. '12-03-2024 22:06'
  fare          NUMERIC
);

CREATE TABLE stg_revenue (
  revenue_id    TEXT,       -- e.g. '1_2024-01-01 00:00:00'
  station_id    INTEGER,
  revenue_date  TEXT,       -- e.g. '01-01-2024'
  total_revenue NUMERIC
);
