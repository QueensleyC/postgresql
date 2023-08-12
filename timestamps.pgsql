/*
1
Find the result of subtracting the timestamp '2012-07-30 01:00:00' FROM the timestamp '2012-08-31 01:00:00'
*/
SELECT timestamp '2012-08-31 01:00:00' - timestamp '2012-07-30 01:00:00' AS interval;  

/*
2
Get the day of the month FROM the timestamp '2012-08-31' AS an integer.
*/
SELECT DATE_PART('month', timestamp '2012-08-31')

ALTERNATIVELY

SELECT extract(day FROM '2012-08-31');

/*
3
Return a count of bookings for each month, sorted by month
*/
SELECT DATE_TRUNC('month', starttime) AS month, count(*)
FROM cd.bookings
GROUP BY month
ORDER BY month  

