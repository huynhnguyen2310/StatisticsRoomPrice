-- Find Wrong Transaction Base Payments
With PaymentStats AS(
	SELECT AVG(amount) AS average_amount,
		STDEV(amount) AS std_amount
	FROM Payments
)
SELECT p.* FROM Payments p
CROSS JOIN PaymentStats
WHERE p.amount > (average_amount + 1.5 * std_amount)
	  OR p.amount < (average_amount - 1.5 * std_amount)
	  ORDER BY amount DESC

-- Find Customer Who Has High Rate Cancelled, check customer who order more than 5 
SELECT b.customer_id,
	COUNT(*) AS total_booking,
	SUM(CASE WHEN b.status = 'Cancelled' THEN 1 ELSE 0 END) AS total_cancelled,
	ROUND((SUM(CASE WHEN b.status = 'Cancelled' THEN 1 ELSE 0 END) * 1.0 / COUNT(*)), 2) AS cancelled_rate
FROM Booking b
GROUP BY b.customer_id
HAVING COUNT(*) > 5 AND (SUM(CASE WHEN b.status = 'Cancelled' THEN 1 ELSE 0 END) * 1.0 / COUNT(*)) > 0.7


-- Find Cheat Customer
SELECT	b.customer_id,
		COUNT(*) AS total_booking,
		SUM(CASE WHEN b.status = 'Cancelled' THEN 1 ELSE 0 END) AS total_cancelled,
		SUM(CASE WHEN price_per_night < 130 THEN 1 ELSE 0 END) low_price_booking,
		ROUND((SUM(CASE WHEN b.status = 'Cancelled' THEN 1 ELSE 0 END) * 1.0 / COUNT(*)), 2) AS cancelled_rate,
		ROUND((SUM(CASE WHEN price_per_night < 130 THEN 1 ELSE 0 END) * 1.0 / COUNT(*)), 2) AS low_price_rate
FROM Booking b
JOIN Room r ON r.room_id = b.room_id
GROUP BY b.customer_id
HAVING  ROUND((SUM(CASE WHEN b.status = 'Cancelled' THEN 1 ELSE 0 END) * 1.0 / COUNT(*)), 2) > 0.7 OR
		ROUND((SUM(CASE WHEN price_per_night < 130 THEN 1 ELSE 0 END) * 1.0 / COUNT(*)), 2)  > 0.5