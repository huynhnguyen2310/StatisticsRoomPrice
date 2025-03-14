WITH BookingStats AS(
	SELECT	b.customer_id,
		COUNT(b.booking_id) AS total_booking,
		SUM(DATEDIFF(DAY, b.check_in, b.check_out)) AS total_day_stayed,
		DATEDIFF(DAY, MAX(b.check_out), GETDATE()) AS days_since_last_booking
	FROM Booking b
	GROUP BY b.customer_id
),

ServiceUsageStats AS(
	SELECT	b.customer_id,
			SUM(quantity) AS total_services_used,
			SUM(total_price) AS total_services_spent
	FROM Services_Usage su 
	JOIN Booking b ON su.booking_id = b.booking_id
	GROUP BY b.customer_id
),

PaymentsStats AS(
	SELECT sb.customer_id, sb.payment_method, total_spent	 
	FROM(
		SELECT b.customer_id, SUM(amount) AS total_spent , p.payment_method,
				RANK() OVER (PARTITION BY b.customer_id ORDER BY COUNT(*) DESC) AS rnk
		FROM Payments p 
		JOIN Booking b ON b.booking_id  = p.booking_id
		GROUP BY b.customer_id, p.payment_method
	) sb
	WHERE sb.rnk = 1	
)

SELECT c.customer_id,
		COALESCE(bs.total_booking, 0) AS total_booking,
		COALESCE(bs.total_day_stayed, 0) AS total_day_stayed,
		COALESCE(bs.days_since_last_booking, 0) AS days_since_last_booking,
		COALESCE(ss.total_services_spent, 0) AS total_services_spent,
		COALESCE(ss.total_services_used, 0) AS total_services_used,
		COALESCE(ps.total_spent, 0) AS total_spent,
		ps.payment_method AS preferred_payment_method,
		CASE
			WHEN COALESCE(bs.days_since_last_booking, 999) > 90 THEN 1	
			ELSE 0
		END AS churn
FROM Customer c
LEFT JOIN BookingStats bs ON bs.customer_id = c.customer_id
LEFT JOIN ServiceUsageStats ss ON ss.customer_id = c.customer_id
LEFT JOIN PaymentsStats ps ON ps.customer_id  = c.customer_id