USE data_interview;

SELECT 
    id,
    status,
    trip_date,
    booking_month,
    days,
    trip_season,
    commission,
    decline_cancel_reason,
    decline_cancel_note,
    location,
    country,
    rating_equipment,
    rating_captain,
    rating_overall
FROM (
    SELECT 
        b.id,
        b.status,
        b.trip_date,
        EXTRACT(MONTH FROM b.trip_date) AS booking_month,
        b.days,
        CASE
            WHEN EXTRACT(MONTH FROM b.trip_date) IN (3, 4, 5) THEN 'Spring'
            WHEN EXTRACT(MONTH FROM b.trip_date) IN (6, 7, 8) THEN 'Summer'
            WHEN EXTRACT(MONTH FROM b.trip_date) IN (9, 10, 11) THEN 'Fall'
            ELSE 'Winter'
        END AS trip_season,
        b.commission,
        CASE
            WHEN status = 'declined' THEN dbr.reason
            WHEN status = 'canceled' THEN cbr.reason
        END AS decline_cancel_reason,
        -- Removing commas and new lines with space for export to csv
        CASE
            WHEN status = 'declined' THEN REPLACE(REPLACE(dbr.reason_note, ',', ' '), '\n', ' ')
            WHEN status = 'canceled' THEN REPLACE(REPLACE(cbr.reason_note, ',', ' '), '\n', ' ')
        END AS decline_cancel_note,
        c.location,
        c.country,
        r.rating_equipment,
        r.rating_captain,
        r.rating_overall
    FROM booking b
    LEFT JOIN cancel_booking_request cbr ON b.id = cbr.booking_id
    LEFT JOIN decline_booking_request dbr ON b.id = dbr.booking_id
    LEFT JOIN charter c ON b.charter_id = c.id
    LEFT JOIN reviews r ON b.id = r.booking_id
) AS subquery
-- WHERE decline_cancel_note LIKE '%Unfortunately the marine forecast for the location we would be fishing is calling for approximately 6 foot seas and thunder storms for the date you have scheduled. In addition  there are still existes some Covid 19 lock-down issues to be considered. Therefore  I will not be running a trip this Sunday primarily due to weather related safety concerns. %'
GROUP BY id;