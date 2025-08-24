-- Test that subscription dates follow logical chronological order
-- Should return 0 rows if all dates are valid
SELECT *
FROM {{ ref('slv_subscriptions') }} AS subs
WHERE (start_date > end_date AND start_date IS NOT NULL AND end_date IS NOT NULL)  -- Start date cannot be after end date
   OR (created_at > start_date AND created_at IS NOT NULL AND start_date IS NOT NULL)  -- Creation cannot be after start