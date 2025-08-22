-- Postgres-compatible versions of analysis queries

-- 1. Find busiest stations by trips
SELECT s.station_name, COUNT(*) AS total_trips
FROM trips t
JOIN stations s ON t.entry_station = s.station_id
GROUP BY s.station_name
ORDER BY total_trips DESC
LIMIT 10;

-- 2. Peak travel hours (Postgres: extract hour)
SELECT to_char(trip_datetime, 'HH24') AS hour_of_day, COUNT(*) AS trips
FROM trips
GROUP BY hour_of_day
ORDER BY trips DESC;

-- 3. Daily revenue across all stations
SELECT revenue_date, SUM(total_revenue) AS daily_revenue
FROM revenue
GROUP BY revenue_date
ORDER BY daily_revenue DESC;

-- 4. Which metro line generates most revenue?
SELECT s.line_name, SUM(r.total_revenue) AS line_revenue
FROM revenue r
JOIN stations s ON r.station_id = s.station_id
GROUP BY s.line_name
ORDER BY line_revenue DESC;

-- 5. Average fare per passenger type
SELECT p.card_type, AVG(t.fare) AS avg_fare
FROM trips t
JOIN passengers p ON t.passenger_id = p.passenger_id
GROUP BY p.card_type;

-- 6. Top 5 frequent travelers
SELECT passenger_id, COUNT(*) AS trips
FROM trips
GROUP BY passenger_id
ORDER BY trips DESC
LIMIT 5;

-- 7. Gender-based travel trends
SELECT p.gender, COUNT(*) AS trips
FROM trips t
JOIN passengers p ON t.passenger_id = p.passenger_id
GROUP BY p.gender;

-- 8. Congestion (entry vs exit imbalance)
SELECT s.station_name,
       (SUM(CASE WHEN t.entry_station = s.station_id THEN 1 ELSE 0 END) -
        SUM(CASE WHEN t.exit_station = s.station_id THEN 1 ELSE 0 END)) AS congestion_gap
FROM trips t
JOIN stations s ON s.station_id = t.entry_station OR s.station_id = t.exit_station
GROUP BY s.station_name
ORDER BY congestion_gap DESC;

-- 9. Most profitable stations
SELECT s.station_name, SUM(r.total_revenue) AS station_revenue
FROM revenue r
JOIN stations s ON r.station_id = s.station_id
GROUP BY s.station_name
ORDER BY station_revenue DESC
LIMIT 10;

-- 10. Passenger Flow Efficiency Index
WITH trip_counts AS (
    SELECT entry_station AS station_id, COUNT(*) AS total_trips
    FROM trips
    GROUP BY entry_station
),
station_revenue AS (
    SELECT station_id, SUM(total_revenue) AS total_revenue
    FROM revenue
    GROUP BY station_id
)
SELECT s.station_name,
       tc.total_trips,
       sr.total_revenue,
       ROUND(CASE WHEN tc.total_trips = 0 THEN NULL ELSE sr.total_revenue / tc.total_trips END, 2) AS efficiency_index
FROM stations s
LEFT JOIN trip_counts tc ON s.station_id = tc.station_id
LEFT JOIN station_revenue sr ON s.station_id = sr.station_id
ORDER BY efficiency_index DESC NULLS LAST;


