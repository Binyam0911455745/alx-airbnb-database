USE alx_airbnb_db;
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    COUNT(b.booking_id) AS total_bookings_made
FROM
    users AS u
LEFT JOIN 
	bookings AS b ON u.user_id = b.guest_id
GROUP BY 
	u.user_id, u.first_name, u.last_name
ORDER BY 
	total_bookings_made DESC, u.last_name, u.first_name;
WITH PropertyBookingCounts AS(
	SELECT
		p.property_id,
        p.name AS property_name,
        COUNT(b.booking_id) AS number_of_bookings
	FROM 
		Properties AS p 
	LEFT JOIN 
		bookings AS b ON p.property_id = b.property_id
	GROUP BY 
        p.property_id, p.name
)
SELECT 
    property_id,
    property_name, 
    number_of_bookings,
    ROW_NUMBER() OVER (ORDER BY number_of_bookings DESC, property_name ASC) AS row_num_rank,
    RANK() OVER (ORDER BY number_of_bookings DESC, property_name ASC) AS rank_properties
FROM
    PropertyBookingCounts
ORDER BY 
	number_of_bookings DESC, property_name ASC;

