-- Clear target tables if re-running
TRUNCATE stations, passengers, trips, revenue RESTART IDENTITY;

-- 1) Dimensions (straight load)
INSERT INTO stations (station_id, station_name, line_name, zone)
SELECT station_id, station_name, line_name, zone
FROM stg_stations;

INSERT INTO passengers (passenger_id, age, gender, card_type)
SELECT passenger_id, age, gender, card_type
FROM stg_passengers;

-- 2) Trips (parse 'DD-MM-YYYY HH24:MI' to TIMESTAMP)
INSERT INTO trips (trip_id, passenger_id, entry_station, exit_station, trip_datetime, fare)
SELECT
  trip_id,
  passenger_id,
  entry_station,
  exit_station,
  TO_TIMESTAMP(trip_datetime, 'DD-MM-YYYY HH24:MI'),
  fare
FROM stg_trips;

-- 3) Revenue (parse 'DD-MM-YYYY' to DATE)
INSERT INTO revenue (revenue_id, station_id, revenue_date, total_revenue)
SELECT
  revenue_id,
  station_id,
  TO_DATE(revenue_date, 'DD-MM-YYYY'),
  total_revenue
FROM stg_revenue
ON CONFLICT (station_id, revenue_date) DO NOTHING;
