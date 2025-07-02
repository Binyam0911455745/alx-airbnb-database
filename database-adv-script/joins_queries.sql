-- Objective: Master SQL joins by writing complex queries using different types of joins.

-- Make sure you are using the correct database
USE alx_airbnb_db;

-- Query 1: Retrieve all bookings and the respective users who made those bookings using an INNER JOIN.
-- This query will only return rows where there is a match in both the 'bookings' and 'users' tables.
SELECT
    b.booking_id,
    b.check_in_date AS start_date,  -- Using check_in_date as start_date as per schema
    b.check_out_date AS end_date,   -- Using check_out_date as end_date as per schema
    b.total_price,
    b.status,
    u.first_name,
    u.last_name,
    u.email
FROM
    bookings AS b
INNER JOIN
    users AS u ON b.guest_id = u.user_id; -- Correct foreign key: bookings.guest_id

-- Query 2: Retrieve all properties and their reviews, including properties that have no reviews, using a LEFT JOIN.
-- This query will return all properties from the 'properties' table, and any matching reviews from the 'reviews' table.
-- If a property has no reviews, the review-related columns will be NULL.
-- NOTE: In your schema, reviews are linked to bookings, not directly to properties.
-- To show property details with reviews, we need to join properties -> bookings -> reviews.
-- This query will show all properties, and if they have any bookings with reviews, those review details.
SELECT
    p.property_id,
    p.name AS property_name,
    p.description AS property_description,
    p.price_per_night, -- Corrected column name as per schema
    r.review_id,
    r.rating,
    r.comment,
    r.created_at AS review_date -- Using created_at from reviews table as review_date
FROM
    properties AS p
LEFT JOIN
    bookings AS b ON p.property_id = b.property_id -- Join properties to bookings
LEFT JOIN
    reviews AS r ON b.booking_id = r.booking_id
ORDER BY
    p.name; -- Added ORDER BY clause for property name

-- Query 3: Retrieve all users and all bookings, even if the user has no booking or a booking is not linked to a user,-- using a combination of LEFT JOIN and RIGHT JOIN (MySQL's equivalent of FULL OUTER JOIN).
SELECT
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    b.booking_id,
    b.check_in_date AS start_date, -- Using check_in_date as start_date
    b.check_out_date AS end_date,  -- Using check_in_date as end_date
    b.total_price,
    b.status
FROM
    users AS u
LEFT JOIN
    bookings AS b ON u.user_id = b.guest_id -- Correct foreign key: bookings.guest_id

UNION

SELECT
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    b.booking_id,
    b.check_in_date AS start_date, -- Using check_in_date as start_date
    b.check_out_date AS end_date,  -- Using check_in_date as end_date
    b.total_price,
    b.status
FROM
    users AS u
RIGHT JOIN
    bookings AS b ON u.user_id = b.guest_id -- Correct foreign key: bookings.guest_id
WHERE
    u.user_id IS NULL; -- This condition ensures only unmatched bookings from the RIGHT JOIN are included in the UNION
