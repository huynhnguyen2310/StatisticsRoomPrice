-- Find empty room
CREATE VIEW empty_room
AS
	SELECT r.room_id, r.room_type FROM  Room r
	JOIN Booking b ON b.room_id = r.room_id
	AND GETDATE() BETWEEN b.check_in AND b.check_out
	WHERE b.booking_id = NULL OR b.status = 'Cancelled'

SELECT * FROM empty_room


CREATE PROCEDURE update_Room
		@customer_id		INT,
		@room_id			INT,
		@check_in		DATE,
		@check_out		DATE
AS
	BEGIN
		SET NOCOUNT ON;
		-- Kiem tra ton tai
		IF EXISTS(SELECT 1 FROM Room WHERE room_id = @room_id AND status = 'Availabel')
		BEGIN 
			INSERT INTO Booking(customer_id, room_id, check_in, check_out, status ,created_at)
			VALUES(@customer_id, @room_id, @check_in, @check_out, 'Confirmed', GETDATE())
			
			-- Cap nhat Room
			UPDATE Room
			SET status = 'Booked'
			WHERE room_id= @room_id

			PRINT('Successful Booking')
		END
		ELSE 
			BEGIN
				PRINT('Error! Because room has already booked')
			END
	END