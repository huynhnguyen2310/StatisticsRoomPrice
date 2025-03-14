CREATE DATABASE MY_PROJECT

USE MY_PROJECT
CREATE TABLE Customer(
	customer_id		INT PRIMARY KEY NOT NULL,
	full_name		VARCHAR(255),
	email			VARCHAR(255),
	phone			VARCHAR(20),
	created_at		DATE
)

CREATE TABLE Room(
	room_id			INT PRIMARY KEY NOT NULL,
	room_number		VARCHAR(10),
	room_type		VARCHAR(50),
	price_per_night	INT,
	status			VARCHAR(20)
)


CREATE TABLE Booking(
	booking_id		INT PRIMARY KEY NOT NULL,
	customer_id		INT,
	room_id			INT,
	check_int		DATE,
	check_out		DATE,
	status			VARCHAR(20),
	created_at		DATE
)


CREATE TABLE Payments(
	payment_id		INT PRIMARY KEY NOT NULL,
	booking_id		INT,
	amout			INT,
	payment_method	VARCHAR(50),
	payment_date	DATE
)

CREATE TABLE Service(
	service_id		INT PRIMARY KEY NOT NULL,
	service_name	VARCHAR(255),
	price			INT
)

CREATE TABLE Services_Usage(
	usage_id		INT PRIMARY KEY NOT NULL,
	booking_id		INT,
	service_id		INT,
	quantity		INT,
	total_price		INT
)

ALTER TABLE Booking
ADD CONSTRAINT FK_Customer FOREIGN KEY(customer_id) REFERENCES Customer(customer_id),
	CONSTRAINT FK_Room	FOREIGN KEY(room_id) REFERENCES Room(room_id)
	
ALTER TABLE Services_Usage
ADD CONSTRAINT FK_Book	FOREIGN KEY(booking_id) REFERENCES Booking(booking_id),
	CONSTRAINT FK_Service	FOREIGN KEY(service_id) REFERENCES Service(service_id)

ALTER TABLE Payments
ADD CONSTRAINT	FK_Payment	FOREIGN KEY(booking_id) REFERENCES Booking(booking_id)