-- 3. Daily revenue across all stations
SELECT revenue_date, SUM(total_revenue) AS daily_revenue
FROM Revenue
GROUP BY revenue_date
ORDER BY daily_revenue DESC;

-- 4. Which metro line generates most revenue?
SELECT s.line_name, SUM(r.total_revenue) AS line_revenue
FROM Revenue r
JOIN Stations s ON r.station_id = s.station_id
GROUP BY s.line_name
ORDER BY line_revenue DESC;
