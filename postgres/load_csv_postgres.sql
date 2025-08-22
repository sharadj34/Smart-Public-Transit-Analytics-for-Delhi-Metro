-- Load CSVs using psql \copy (client-side)
-- Ensure you run psql from the repo root so paths resolve.
\copy stations(station_id, station_name, line_name, zone) FROM 'Datasets/DelhiMetro_Stations.csv' WITH (FORMAT csv, HEADER true)
\copy passengers(passenger_id, age, gender, card_type) FROM 'Datasets/DelhiMetro_Passengers.csv' WITH (FORMAT csv, HEADER true)
\copy trips(trip_id, passenger_id, entry_station, exit_station, trip_datetime, fare) FROM 'Datasets/DelhiMetro_Trips.csv' WITH (FORMAT csv, HEADER true)
\copy revenue(revenue_id, station_id, revenue_date, total_revenue) FROM 'Datasets/DelhiMetro_Revenue.csv' WITH (FORMAT csv, HEADER true)


