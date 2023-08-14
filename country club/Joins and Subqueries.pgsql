/*
1
How can you produce a list of the start times
for bookings by members named 'David Farrell'?
*/

SELECT bks.starttime 
FROM cd.bookings bks
INNER JOIN cd.members mems
ON mems.memid = bks.memid
WHERE mems.firstname='David' 
	  AND mems.surname='Farrell'; 

/*
2
How can you produce a list of the start times
for bookings for tennis courts, for the date'2012-09-21'?
Return a list of start time AND facility name pairings, 
ordered by the time.
*/

SELECT bks.starttime AS start, facs.name AS name
FROM cd.facilities facs
INNER JOIN cd.bookings bks
ON facs.facid = bks.facid
WHERE facs.name IN ('Tennis Court 2','Tennis Court 1') AND
	  bks.starttime >= '2012-09-21' AND
	  bks.starttime < '2012-09-22'
ORDER BY bks.starttime; 


-- SELF JOIN
/*
3
How can you output a list of all members 
who have recommended another member? 
Ensure that there are no duplicates IN the list,
AND that results are ordered by (surname, firstname).
*/

SELECT DISTINCT recs.firstname AS firstname, recs.surname AS surname
FROM cd.members mems
INNER JOIN cd.members recs
ON recs.memid = mems.recommendedby
ORDER BY surname, firstname; 

/*
4
How can you output a list of all members,
including the individual who recommended them (if any)?
Ensure that results are ordered by (surname, firstname).
*/

SELECT mems.firstname AS memfname, mems.surname AS memsname, recs.firstname AS recfname, recs.surname AS recsname
FROM cd.members mems
LEFT JOIN cd.members recs
ON recs.memid = mems.recommendedby
ORDER BY memsname, memfname;  



-- Three joins

/*
5
How can you produce a list of all members who have used a tennis court?
Include IN your output the name of the court,
AND the name of the member formatted AS a single column. 
Ensure no duplicate data, 
AND ORDER BY the member name followed by the facility name.
*/

SELECT DISTINCT mems.firstname || ' ' || mems.surname AS member, facs.name AS facility
FROM cd.members mems
INNER JOIN cd.bookings bks
ON mems.memid = bks.memid
INNER JOIN cd.facilities facs
ON bks.facid = facs.facid
WHERE facs.name LIKE 'Tennis Court %' 
ORDER BY member, facility;  

/*
6
How can you produce a list of bookings ON the day of 2012-09-14
which will cost the member (or guest) more than $30?
Remember that guests have different costs to members 
(the listed costs are per half-hour 'slot'), 
AND the guest user is always ID 0.
Include IN your output the name of the facility, 
the name of the member formatted AS a single column, AND the cost. 
Order by descending cost, AND do not use any subqueries.
*/

SELECT mems.firstname || ' ' || mems.surname AS member, 
	facs.name AS facility, 
	CASE 
		WHEN mems.memid = 0 THEN
			bks.slots*facs.guestcost
		ELSE
			bks.slots*facs.membercost
	END AS cost
FROM cd.members mems                
INNER JOIN cd.bookings bks
ON mems.memid = bks.memid
INNER JOIN cd.facilities facs
ON bks.facid = facs.facid
WHERE bks.starttime >= '2012-09-14' AND 
	  bks.starttime < '2012-09-15' AND (
			(mems.memid = 0 AND bks.slots*facs.guestcost > 30) or
			(mems.memid != 0 AND bks.slots*facs.membercost > 30)
		)
ORDER BY cost desc; 


-- Subqueries
/*
7
Produce a list of all members, alONg with their recommender, using no joins.
*/

SELECT DISTINCT mems.firstname || ' ' ||  mems.surname AS member,
	(SELECT recs.firstname || ' ' || recs.surname AS recommender 
		FROM cd.members recs 
		WHERE recs.memid = mems.recommendedby
	)
FROM cd.members mems
ORDER BY member;  

/*
8
Rewriting questiON 6 AS a subquery
*/

SELECT member, facility, cost 
FROM (
	SELECT 
		mems.firstname || ' ' || mems.surname AS member,
		facs.name AS facility,
		CASE
			WHEN mems.memid = 0 THEN
				bks.slots*facs.guestcost
			ELSE
				bks.slots*facs.membercost
		END AS cost
		FROM
			cd.members mems
			INNER JOIN cd.bookings bks
				ON mems.memid = bks.memid
			INNER JOIN cd.facilities facs
				ON bks.facid = facs.facid
		WHERE
			bks.starttime >= '2012-09-14' AND
			bks.starttime < '2012-09-15'
	) AS bookings
	WHERE cost > 30
ORDER BY cost desc;     