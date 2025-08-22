-- Passenger Flow Efficiency Index (Revenue per Trip per Station)

WITH trip_counts AS (
    SELECT entry_station AS station_id, COUNT(*) AS total_trips
    FROM Trips
    GROUP BY entry_station
),
station_revenue AS (
    SELECT station_id, SUM(total_revenue) AS total_revenue
    FROM Revenue
    GROUP BY station_id
)
SELECT s.station_name,
       tc.total_trips,
       sr.total_revenue,
       ROUND(sr.total_revenue / NULLIF(tc.total_trips,0), 2) AS efficiency_index
FROM Stations s
LEFT JOIN trip_counts tc ON s.station_id = tc.station_id
LEFT JOIN station_revenue sr ON s.station_id = sr.station_id
ORDER BY efficiency_index DESC;
