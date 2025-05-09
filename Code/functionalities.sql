CREATE OR ALTER PROCEDURE CheckUserLogin
    @Username NVARCHAR(100),
    @Password NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Declare variables to store the result
    DECLARE @LoginSuccess BIT = 0;
    DECLARE @UserID INT = NULL;
    DECLARE @UserEmail NVARCHAR(30) = NULL;
    DECLARE @LoyaltyPoints INT = 0;
    
    -- Check if username and password match
    SELECT 
        @UserID = userID,
        @UserEmail = email,
        @LoyaltyPoints = loyaltypoints
    FROM 
        users 
    WHERE 
        username = @Username 
        AND password = @Password;
    
    -- Set login success flag if user was found
    IF @UserID IS NOT NULL
        SET @LoginSuccess = 1;
    
    -- Return the result with user information
    SELECT 
        @LoginSuccess AS LoginSuccess,
        @UserID AS UserID,
        @Username AS Username,
        @UserEmail AS Email,
        @LoyaltyPoints AS LoyaltyPoints;
    
    -- Optional: Update last login timestamp if needed
    -- (would require adding a last_login column to users table)
    -- UPDATE users SET last_login = GETDATE() WHERE userID = @UserID;
END;


EXEC CheckUserLogin @Username = 'testuser', @Password = 'test123';




SELECT * FROM admins 
WHERE admin_name = 'Admin Ali' 
AND adminID IN (SELECT adminID FROM admins WHERE warehouse_no = 1);



--This query verifies admin credentials and checks if they're assigned to a specific warehouse.



- -Basic Car Search
SELECT car_no, car_name, car_miles, car_booking_price 
FROM cars 
WHERE car_name LIKE '%Toyota%';

--Finds all cars with "Toyota" in their name using the LIKE operator.

--Advanced Car Search with Warehouse Info
SELECT c.car_no, c.car_name, c.car_miles, c.car_booking_price, 
       w.warehouse_name, w.warehouse_number
FROM cars c
JOIN warehouse w ON c.warehouse_no = w.warehouse_no
WHERE c.car_booking_price BETWEEN 4000 AND 6000
ORDER BY c.car_booking_price DESC;

--Joins cars with warehouse information and filters by price range, sorted by price.





--Warehouse Search with Car Count
SELECT w.warehouse_no, w.warehouse_name, COUNT(c.car_no) AS car_count
FROM warehouse w
LEFT JOIN cars c ON w.warehouse_no = c.warehouse_no
GROUP BY w.warehouse_no, w.warehouse_name
HAVING COUNT(c.car_no) > 0;

--Shows warehouses with the count of available cars, excluding empty warehouses.

--Specific Warehouse Search

SELECT * FROM warehouse 
WHERE warehouse_name LIKE '%Lahore%';


--Finds warehouses located in Lahore using LIKE for partial matching.





--New Booking Insert

INSERT INTO bookings (userID, warehouse_no, carsbooked)
VALUES (1, 2, 1);



--Adds a new booking record for a user at a specific warehouse.




--Booking with Validation
-- First check car availability
DECLARE @Available INT;
SELECT @Available = COUNT(*) FROM cars WHERE warehouse_no = 3 AND car_no = 105;

IF @Available > 0
BEGIN
    INSERT INTO bookings (userID, warehouse_no, carsbooked)
    VALUES (1, 3, 1);
    SELECT 'Booking successful' AS Result;
END
ELSE
    SELECT 'Car not available' AS Result;


--Checks car availability before creating a booking.





--Remove Booking

DELETE FROM bookings 
WHERE userID = 1 AND warehouse_no = 1;


--Deletes a specific booking record.


--Conditional Booking Deletion


DELETE FROM bookings
WHERE userID IN (SELECT userID FROM users WHERE username = 'testuser')
AND warehouse_no = 2;


--Deletes bookings for a specific user at a specific warehouse using a subquery.




--View Pending Bookings
SELECT b.userID, u.username, b.warehouse_no, w.warehouse_name, b.carsbooked
FROM bookings b
JOIN users u ON b.userID = u.userID
JOIN warehouse w ON b.warehouse_no = w.warehouse_no
WHERE b.warehouse_no IN (SELECT warehouse_no FROM admins WHERE admin_name = 'Admin Ali');

--Shows bookings for warehouses managed by a specific admin.

--Update Booking Status (Accept/Decline)
-- This would typically update a status column (would need to be added to schema)
-- For demonstration, we'll delete declined bookings

DELETE FROM bookings
WHERE userID = 1 AND warehouse_no = 1
AND carsbooked = (SELECT MIN(carsbooked) FROM bookings WHERE userID = 1);


--Simulates declining a booking by removing it (in a real system, you'd update a status field).



--Update Username

UPDATE users
SET username = 'newusername'
WHERE userID = 1 AND password = '123456789’';


--Changes username with password verification.



--Update Password


UPDATE users
SET password = '12345678’'
WHERE username = 'testuser' AND password = '12345’';


--Changes password after verifying old password.


Admin Username Update
UPDATE admins
SET admin_name = 'NewAdminName'
WHERE adminID = 1 AND warehouse_no = 1;



--Updates admin username with warehouse verification.



--Admin Password Update
-- This would require schema modification
-- For demonstration, we'll assume it exists
UPDATE admins
SET password = 'newadminpass'
WHERE adminID = 1;



--Hypothetical query to update admin password (schema would need modification).



--Insert New Car


INSERT INTO cars (car_no, warehouse_no, car_name, car_miles, car_booking_price)
VALUES (108, 3, 'MG HS', 12000, 7500);

--Adds a new car to a warehouse.


--Bulk Car Insert
INSERT INTO cars (car_no, warehouse_no, car_name, car_miles, car_booking_price)
VALUES 
    (109, 4, 'Toyota Fortuner', 18000, 8500),
    (110, 4, 'Suzuki Swift', 22000, 4000);


--Adds multiple cars at once.



--Insert New Warehouse




INSERT INTO warehouse (warehouse_name, warehouse_number)
VALUES ('Faisalabad Auto Hub', '+923411234567');

--Creates a new warehouse record.
--Add Warehouse with Admin Assignment



BEGIN TRANSACTION;
    DECLARE @NewWarehouseID INT;
    
    INSERT INTO warehouse (warehouse_name, warehouse_number)
    VALUES ('Quetta Storage', '+923811234567');
    
    SET @NewWarehouseID = SCOPE_IDENTITY();
    
    INSERT INTO admins (admin_name, warehouse_no)
    VALUES ('Admin Khan', @NewWarehouseID);
COMMIT;



--Adds a new warehouse and assigns an admin in a transaction.




--View for User Bookings

CREATE VIEW UserBookingsView AS
SELECT u.username, w.warehouse_name, c.car_name, b.carsbooked
FROM bookings b
JOIN users u ON b.userID = u.userID
JOIN warehouse w ON b.warehouse_no = w.warehouse_no
LEFT JOIN cars c ON b.warehouse_no = c.warehouse_no;

--Creates a view to easily see user bookings with related information.

--Car Statistics Procedure
CREATE PROCEDURE GetCarStatistics
AS
BEGIN
    SELECT 
        AVG(car_booking_price) AS avg_price,
        MIN(car_booking_price) AS min_price,
        MAX(car_booking_price) AS max_price,
        SUM(car_booking_price) AS total_value
    FROM cars;
END;
--Provides statistical information about cars in the system.

--Union Query for All Locations
SELECT location FROM users
UNION
SELECT warehouse_location FROM warehouse;

--Combines user locations and warehouse locations (note: warehouse_location would need to be added).

Intersection Query
SELECT userID FROM users
INTERSECT
SELECT userID FROM bookings;

--Finds users who have made bookings.

--Nested Query for Popular Cars
SELECT car_name, car_booking_price
FROM cars
WHERE warehouse_no IN (
    SELECT warehouse_no 
    FROM bookings 
    GROUP BY warehouse_no 
    HAVING COUNT(*) > 1
);

--Shows cars in warehouses with more than 1 booking.

--Right Join Example
SELECT w.warehouse_name, c.car_name
FROM cars c
RIGHT JOIN warehouse w ON c.warehouse_no = w.warehouse_no;


--Shows all warehouses, even those without cars.
--Group By with Having
SELECT warehouse_no, COUNT(*) AS car_count
FROM cars
GROUP BY warehouse_no
HAVING COUNT(*) > 1;
--Finds warehouses with more than one car.

--Outer Join Example
SELECT u.username, b.carsbooked
FROM users u
FULL OUTER JOIN bookings b ON u.userID = b.userID;


--Shows all users and all bookings, matching where possible.
 

