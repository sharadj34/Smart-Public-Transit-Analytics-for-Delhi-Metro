-- Drop if re-running
DROP TABLE IF EXISTS revenue CASCADE;
DROP TABLE IF EXISTS trips CASCADE;
DROP TABLE IF EXISTS passengers CASCADE;
DROP TABLE IF EXISTS stations CASCADE;

-- Dimension tables
CREATE TABLE stations (
  station_id   INTEGER PRIMARY KEY,
  station_name TEXT    NOT NULL,
  line_name    TEXT    NOT NULL,
  zone         TEXT
);

CREATE TABLE passengers (
  passenger_id INTEGER PRIMARY KEY,
  age          INTEGER,
  gender       TEXT,
  card_type    TEXT
);

-- Fact tables
CREATE TABLE trips (
  trip_id       INTEGER PRIMARY KEY,
  passenger_id  INTEGER REFERENCES passengers(passenger_id),
  entry_station INTEGER REFERENCES stations(station_id),
  exit_station  INTEGER REFERENCES stations(station_id),
  trip_datetime TIMESTAMP,
  fare          NUMERIC(10,2)
);

CREATE TABLE revenue (
  -- keep raw id if you want to trace, but don't rely on it as PK
  revenue_id    TEXT,
  station_id    INTEGER REFERENCES stations(station_id),
  revenue_date  DATE,
  total_revenue NUMERIC(12,2),
  CONSTRAINT uq_revenue UNIQUE (station_id, revenue_date)
);

-- Helpful indexes
CREATE INDEX idx_trips_datetime    ON trips (trip_datetime);
CREATE INDEX idx_trips_entry       ON trips (entry_station);
CREATE INDEX idx_trips_exit        ON trips (exit_station);
CREATE INDEX idx_revenue_station   ON revenue (station_id);
CREATE INDEX idx_revenue_date      ON revenue (revenue_date);
