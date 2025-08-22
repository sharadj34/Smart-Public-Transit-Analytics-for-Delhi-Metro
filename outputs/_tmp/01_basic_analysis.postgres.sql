-- 1. Find busiest stations by trips
SELECT s.station_name, COUNT(*) AS total_trips
FROM Trips t
JOIN Stations s ON t.entry_station = s.station_id
GROUP BY s.station_name
ORDER BY total_trips DESC
LIMIT 10;

-- 2. Peak travel hours
SELECT to_char(trip_datetime, 'HH24') AS hour_of_day, COUNT(*) AS trips
FROM Trips
GROUP BY hour_of_day
ORDER BY trips DESC;
