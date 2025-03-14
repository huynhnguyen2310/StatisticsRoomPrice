-- Create CTE
WITH BookingData AS(
	SELECT  
		Customer.customer_id, Customer.full_name,
		COUNT(Booking.booking_id) AS total_booking,
		AVG(DATEDIFF(DAY, check_in, check_out)) AS total_day_stayed,
		SUM(amount) AS total_spent
 		FROM Customer
	LEFT JOIN Booking ON Booking.customer_id = Customer.customer_id
	LEFT JOIN Payments ON Payments.booking_id = Booking.booking_id
	GROUP BY Customer.customer_id, Customer.full_name
),

ServiceUsageData AS(
	SELECT customer_id, 
			COUNT(service_id) AS total_services_used,
			SUM(total_price) AS total_services_spent
	FROM Booking
	JOIN Services_Usage ON Services_Usage.booking_id = Booking.booking_id
	GROUP BY customer_id
)
SELECT 
		bd.customer_id,
		bd.full_name,
		bd.total_booking,
		bd.total_day_stayed,
		bd.total_spent,
		COALESCE(su.total_services_used, 0) AS total_services_used,
		COALESCE(su.total_services_spent, 0) AS total_services_spent 
	FROM BookingData bd
	LEFT JOIN ServiceUsageData su ON bd.customer_id = su.customer_id
	ORDER BY total_spent DESC
