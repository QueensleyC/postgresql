/*
How can you produce a list of the start times
for bookings by members named 'David Farrell'?
*/

SELECT bks.starttime 
FROM cd.bookings bks
inner join cd.members mems
on mems.memid = bks.memid
where mems.firstname='David' 
	  and mems.surname='Farrell'; 

/*
How can you produce a list of the start times
for bookings for tennis courts, for the date'2012-09-21'?
Return a list of start time and facility name pairings, 
ordered by the time.
*/

select bks.starttime as start, facs.name as name
from cd.facilities facs
inner join cd.bookings bks
on facs.facid = bks.facid
where facs.name in ('Tennis Court 2','Tennis Court 1') and
	  bks.starttime >= '2012-09-21' and
	  bks.starttime < '2012-09-22'
order by bks.starttime; 


-- SELF JOIN
/*
How can you output a list of all members 
who have recommended another member? 
Ensure that there are no duplicates in the list,
and that results are ordered by (surname, firstname).
*/

select distinct recs.firstname as firstname, recs.surname as surname
from cd.members mems
inner join cd.members recs
on recs.memid = mems.recommendedby
order by surname, firstname; 

/*
How can you output a list of all members,
including the individual who recommended them (if any)?
Ensure that results are ordered by (surname, firstname).
*/

select mems.firstname as memfname, mems.surname as memsname, recs.firstname as recfname, recs.surname as recsname
from cd.members mems
left outer join cd.members recs
on recs.memid = mems.recommendedby
order by memsname, memfname;  

