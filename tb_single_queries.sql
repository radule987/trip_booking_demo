USE data_interview;

-- Favored destination for bookings
SELECT location, country, public, COUNT(*) AS booking_count
FROM charter
WHERE location IS NOT NULL
GROUP BY location
ORDER BY booking_count DESC;

-- Peak booking times
SELECT EXTRACT(MONTH FROM trip_date) AS booking_month, COUNT(*) AS booking_count
FROM booking
WHERE status = 'done'
GROUP BY booking_month
ORDER BY booking_count DESC;
    
-- Seasonal Demand Shifts
SELECT
    CASE
        WHEN EXTRACT(MONTH FROM trip_date) IN (3, 4, 5) THEN 'Spring'
        WHEN EXTRACT(MONTH FROM trip_date) IN (6, 7, 8) THEN 'Summer'
        WHEN EXTRACT(MONTH FROM trip_date) IN (9, 10, 11) THEN 'Fall'
        ELSE 'Winter'
    END AS season,
COUNT(*) AS booking_count
FROM booking
WHERE status = 'done'
GROUP BY season
ORDER BY season;
    
-- Analyzing Customer Satisfaction Trends
SELECT rating_overall, COUNT(*) AS rating_count
FROM reviews
WHERE booking_id IN (SELECT id FROM booking WHERE status = 'done')
GROUP BY rating_overall
ORDER BY rating_overall DESC;

-- Cancellation reasons and counts
SELECT reason, COUNT(*) AS cancellation_count
FROM cancel_booking_request
GROUP BY reason
ORDER BY cancellation_count DESC;