--COUNTS

/* 
1
COUNT the number of facilities
*/
SELECT COUNT(*) FROM cd.facilities; 

/*
2
Produce a COUNT of the number of facilities that have a cost to guests of 10 or more.
*/
SELECT COUNT(*) FROM cd.facilities WHERE guestcost >= 10; 

/* 
3
Produce a COUNT of the number of recommendations each member has made. ORDER BY member ID.
*/
SELECT recommendedby, COUNT(*) 
FROM cd.members
WHERE recommendedby IS NOT NULL
GROUP BY recommendedby
ORDER BY recommendedby;   

/* 
4
List the total slots booked per facility
*/
SELECT facid, SUM(slots) AS "Total Slots"
FROM cd.bookings
GROUP BY facid
ORDER BY facid; 

/* 
5
List the total slots booked per facility in the month of September 2012
*/
SELECT facid, SUM(slots) AS "Total Slots"
FROM cd.bookings
WHERE starttime >= '2012-09-01'
      AND starttime < '2012-10-01'
GROUP BY facid
ORDER BY SUM(slots);  

/* 
6
List the total slots booked per facility per month in the year of 2012
*/
SELECT facid, DATE_PART('month', starttime) AS month, SUM(slots) AS "Total Slots"
FROM cd.bookings
WHERE extract(year FROM starttime) = 2012
GROUP BY facid, month
ORDER BY facid, month;   

/* 
7
Find the total number of members (including guests) who have made at least one booking.
*/
SELECT COUNT(*) 
FROM (SELECT distinct memid FROM cd.bookings) AS mems

/* 
8
List facilities with more than 1000 slots booked
*/
SELECT facid, SUM(slots) AS "Total Slots"
FROM cd.bookings
GROUP BY facid
HAVING SUM(slots) > 1000
ORDER BY facid  

/* 
9
Find the total revenue of each facility
*/
SELECT facs.name, 
        SUM(slots * CASE
			WHEN memid = 0 THEN facs.guestcost
			ELSE facs.membercost
		    END) AS revenue
FROM cd.bookings bks
JOIN cd.facilities facs
ON bks.facid = facs.facid
GROUP BY facs.name
ORDER BY revenue;  

/* 
10
Find facilities with a total revenue less than 1000
*/
SELECT name, revenue 
FROM (SELECT facs.name, 
                SUM(CASE WHEN memid = 0 THEN slots * facs.guestcost
				        ELSE slots * membercost
			        END) AS revenue
		FROM cd.bookings bks
		JOIN cd.facilities facs
		ON bks.facid = facs.facid
		GROUP BY facs.name
	) AS agg 
WHERE revenue < 1000
ORDER BY revenue;  

/* 
11
Output the facility id that has the highest number of slots booked*/
SELECT facid, SUM(slots) AS "Total Slots"
FROM cd.bookings
GROUP BY facid
ORDER BY SUM(slots) DESC
LIMIT 1;   

/*12
Produce a list of the total number of slots booked per facility per month in the year of 2012. 
Return null values in the month and facid columns. */
SELECT facid, DATE_PART('month', starttime) AS month, sum(slots) AS slots
FROM cd.bookings
WHERE starttime >= '2012-01-01'
      AND starttime < '2013-01-01'
GROUP BY rollup(facid, month)
ORDER BY 1, 2;  

/*12
Produce a list of the total number of hours booked per facility, remembering that a slot lasts half an hour.
Try formatting the hours to two decimal places.*/
SELECT facs.facid, facs.name,
	trim(to_char(sum(bks.slots)/2.0, '9999999999999999D99')) AS "Total Hours"
FROM cd.bookings bks
JOIN cd.facilities facs
ON facs.facid = bks.facid
GROUP BY 1,2
ORDER BY 1;    

/*13
Produce a list of each member name, id, AND their first booking after September 1st 2012. ORDER BY member ID.*/
SELECT mems.surname, mems.firstname, mems.memid, min(bks.starttime) AS starttime
FROM cd.bookings bks
JOIN cd.members mems 
ON mems.memid = bks.memid
WHERE starttime >= '2012-09-01'
GROUP BY 1,2,3
ORDER BY 3;  

/*14
Produce a list of member names, with each row containing the total member count. 
ORDER BY join date, AND include guest members. */

SELECT count(*) OVER(), firstname, surname
FROM cd.members
ORDER BY joindate   

/*15
Produce a monotonically increasing numbered list of members (including guests), 
ordered by their date of joining. Remember that member IDs are not guaranteed to be sequential. */
SELECT row_number() OVER(ORDER BY joindate), firstname, surname
FROM cd.members
ORDER BY joindate    

/*16
Output the facility id that has the highest number of slots booked. 
Ensure that in the event of a tie, all tieing results get output. */
SELECT facid, total 
FROM (
	SELECT facid, sum(slots) total, rank() OVER (ORDER BY sum(slots) DESC) rank
        FROM cd.bookings
		GROUP BY facid
	) AS ranked
WHERE rank = 1  

/*17
Produce a list of members (including guests), along with the number of hours they've booked in facilities,
rounded to the nearest ten hours. Rank them by this rounded figure, 
producing output of first name, surname, rounded hours, rank. Sort by rank, surname, AND first name. */
SELECT firstname, surname,
	((sum(bks.slots)+10)/20)*10 AS hours,
	rank() OVER (ORDER BY ((sum(bks.slots)+10)/20)*10 DESC) AS rank

FROM cd.bookings bks
JOIN cd.members mems
ON bks.memid = mems.memid
GROUP BY mems.memid
ORDER BY rank, 2, 1;  

/*18
Produce a list of the top three revenue generating facilities (including ties).
Output facility name AND rank, sorted by rank AND facility name. */

SELECT name, rank 
FROM (
	SELECT facs.name AS name, 
            rank() OVER (ORDER BY sum(CASE
				WHEN memid = 0 THEN slots * facs.guestcost
				ELSE slots * membercost
			END) DESC) AS rank
    FROM cd.bookings bks
    JOIN cd.facilities facs
    ON bks.facid = facs.facid
    GROUP BY facs.name
	) AS subq
WHERE rank <= 3
ORDER BY 2;  

/*19
Classify facilities into equally sized groups of high, average, AND low based ON their revenue.
ORDER BY classification AND facility name. */

WITH subq AS (SELECT facs.name AS name, 
                NTILE(3) OVER (ORDER BY sum(CASE
                    WHEN memid = 0 THEN slots * facs.guestcost
                    ELSE slots * membercost END)
                    DESC) AS class
		FROM cd.bookings bks
		JOIN cd.facilities facs
		ON bks.facid = facs.facid
		GROUP BY facs.name)

SELECT name, CASE WHEN class=1 THEN 'high'
		WHEN class=2 THEN 'average'
		ELSE 'low'
		END revenue
FROM subq
ORDER BY class, name;      


