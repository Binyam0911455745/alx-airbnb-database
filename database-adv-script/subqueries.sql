USE alx_airbnb_db;
SELECT 
    p.property_id,
    p.name AS property_name,
    p.price_per_night
FROM 
    properties AS p
WHERE 
    p.property_id IN (
		SELECT 
		    b.property_id
		FROM
            bookings AS b 
		INNER JOIN 
			reviews AS r ON b.booking_id = r.booking_id
		GROUP BY 
            b.property_id
		HAVING
            AVG(r.rating) > 4.0
            );
SELECT
    u.user_id,
    u.first_name,
    u.last_name,
    u.email
FROM
    users AS u
WHERE(
   SELECT
      COUNT(b.booking_id)
   FROM
	  bookings AS b 
   WHERE
      b.guest_id = u.user_id 
) > 3;
