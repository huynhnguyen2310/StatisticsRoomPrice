-- Price Avg 
SELECT  room_type, AVG(price_per_night) AS 'AVG Price' FROM Room
	GROUP BY  room_type
	ORDER BY [AVG Price] DESC

-- Check Min_Price, Max_Price
SELECT  MAX(price_per_night)  AS 'Max Price', 
		MIN(price_per_night) AS 'Min Price'
		FROM Room

-- Check total_amount per room
SELECT TOP(10) Room.room_id , room_type, SUM(amount) AS 'Total Amount' FROM Room
	JOIN Booking ON Booking.room_id = Room.room_id
	JOIN Payments ON Payments.booking_id = Booking.booking_id
	GROUP BY Room.room_id, room_type
	ORDER BY [Total Amount] DESC


-- Relasionship Booking and Room Price
SELECT price_per_night, COUNT(booking_id) AS 'Booked' FROM Room
	JOIN Booking ON Booking.room_id = Room.room_id
	GROUP BY price_per_night
	ORDER BY price_per_night

-- Trend By Season
SELECT DATEPART(MONTH, check_in) AS 'Thang', AVG(price_per_night) AS 'AVG_PRICE' FROM Booking
	JOIN Room ON Booking.room_id = Room.room_id
	GROUP BY DATEPART(MONTH,check_in)
	ORDER BY Thang