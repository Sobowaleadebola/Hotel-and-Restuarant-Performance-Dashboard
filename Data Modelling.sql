/*          Observations            */
-- Multiple null values in booking start and stop dates
-- Inconsistent dates (year = 1916) in bookings table
-- Inconsistent spelling in Room type for request table so need for PK in Room table
-- Occupants were more than capacity
-- No PK in food order table. This would've made joining to Room table easier


---All tables----
SELECT * FROM requests
SELECT * FROM bookings
SELECT * FROM rooms;
SELECT * FROM food_orders
SELECT * FROM menu

----Proper data modelling and segmentation of entities to load on Power BI for Visualization---

----###--Using subquery to calculate number of rooms and number of days booked by each client--###---------
SELECT request_id, 
client_name, 
Room_Type,
COUNT(Room_number) No_of_rooms_booked, 
request_type, 
Booking_stdt, 
Booking_endt, 
DATEDIFF(DAY,Booking_stdt,Booking_endt) AS No_of_days_booked, 
adults,
children 
--INTO Booking_Requests
FROM (SELECT
Rq.request_id,
Rq.client_name,
Rq.request_type,
Rq.start_date,
Rq.end_date,
Rq.adults,
Rq.children,
B.id AS Booking_id,
Rq.room_type,
B.Room AS Room_number,
B.start_date AS Booking_stdt,
B.end_date AS Booking_endt
FROM Requests Rq
LEFT JOIN Bookings B
ON Rq.request_id = B.request_id) Bookings_Table
GROUP BY request_id,client_name,request_type,Booking_stdt,Booking_endt,adults,children, room_type
ORDER BY request_id;



----###--Food Order Menu Table--###--------------
SELECT
F.bill_room AS Billing_room,
Rm.[type] AS Room_Type,
F.dest_room AS Order_destination,
F.Menu_id,
M.category AS Menu_Categoryy,
M.name AS Menu_name,
M.price AS Menu_Price,
F.orders AS No_of_Order,
F.orders*m.price AS Order_Price,
F.date AS Food_Date,
F.Time AS Food_Time,
M.id AS Menu_no
--SUBSTRING(fo.bill_room,1,1) AS Room_Prefix
INTO Food_Order_Menu
FROM Food_orders F
 JOIN Menu M
ON F.menu_id = M.id
LEFT JOIN rooms AS Rm 
ON SUBSTRING(F.bill_room,1,1) = Rm.prefix
ORDER BY F.bill_room

--Verify Table---
SELECT * FROM Food_Order_Menu

SELECT Room_Type, COUNT(No_of_order) AS Orders
FROM Food_Order_Menu
GROUP BY Room_Type
ORDER BY Room_Type