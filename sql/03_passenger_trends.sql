-- 5. Average fare per passenger type
SELECT p.card_type, AVG(t.fare) AS avg_fare
FROM Trips t
JOIN Passengers p ON t.passenger_id = p.passenger_id
GROUP BY p.card_type;

-- 6. Top 5 frequent travelers
SELECT passenger_id, COUNT(*) AS trips
FROM Trips
GROUP BY passenger_id
ORDER BY trips DESC
LIMIT 5;

-- 7. Gender-based travel trends
SELECT p.gender, COUNT(*) AS trips
FROM Trips t
JOIN Passengers p ON t.passenger_id = p.passenger_id
GROUP BY p.gender;
