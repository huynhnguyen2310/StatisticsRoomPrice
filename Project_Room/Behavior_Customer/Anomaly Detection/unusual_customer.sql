
WITH BookingStats AS(
		SELECT b.customer_id,
			   b.booking_id,
			   b.check_in,
			   b.check_out,
			   LAG(b.check_in) OVER (PARTITION BY b.customer_id ORDER BY b.check_in) AS prev_check_in,
			   DATEDIFF(DAY, LAG(b.check_in) OVER (PARTITION BY b.customer_id ORDER BY b.check_in), b.check_in) AS day_betweens
		FROM Booking b
)
SELECT  b.customer_id,
		COUNT(*) AS total_booking,
		ROUND((SUM(CASE WHEN b.status = 'Cancelled' THEN 1 ELSE 0 END) * 1.0 / COUNT(*)), 2) AS cancelled_rate,
		ROUND((SUM(CASE WHEN r.price_per_night < 130 THEN 1 ELSE 0 END) * 1.0 / COUNT(*)), 2) AS low_price_booking_rate,
		AVG(BookingStats.day_betweens) AS avg_day_between,
		SUM(DATEDIFF(DAY, b.check_in, b.check_out)) AS total_day_stayed
FROM Booking b
JOIN Room r ON r.room_id = b.room_id
JOIN BookingStats ON BookingStats.customer_id = b.customer_id AND BookingStats.booking_id = b.booking_id
GROUP BY b.customer_id