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


