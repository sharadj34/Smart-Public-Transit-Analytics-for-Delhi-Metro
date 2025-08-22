-- 8. Congestion (entry vs exit imbalance)
SELECT s.station_name,
       (SUM(CASE WHEN t.entry_station = s.station_id THEN 1 ELSE 0 END) -
        SUM(CASE WHEN t.exit_station = s.station_id THEN 1 ELSE 0 END)) AS congestion_gap
FROM Trips t
JOIN Stations s ON s.station_id = t.entry_station OR s.station_id = t.exit_station
GROUP BY s.station_name
ORDER BY congestion_gap DESC;

-- 9. Most profitable stations
SELECT s.station_name, SUM(r.total_revenue) AS station_revenue
FROM Revenue r
JOIN Stations s ON r.station_id = s.station_id
GROUP BY s.station_name
ORDER BY station_revenue DESC
LIMIT 10;
