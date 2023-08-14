-- INSERTION

/*
1
The club is adding a new facility - a spa. 
We need to add it INTO the facilities table.
Use the following VALUES:
facid: 9, Name: 'Spa', membercost: 20, 
guestcost: 30, initialoutlay: 100000, monthlymaintenance: 800.
*/

INSERT INTO cd.facilities
(facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
VALUES (9, 'Spa', 20, 30, 100000, 800);  

ALTERNATIVELY

INSERT INTO cd.facilities
VALUES (9, 'Spa', 20, 30, 100000, 800);  

/*
2
Insert multiple rows of data INTO a table
*/
INSERT INTO cd.facilities
(facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
VALUES
(9, 'Spa', 20, 30, 100000, 800),
(10, 'Squash Court 2', 3.5, 17.5, 5000, 80);  


/*
3
Insert calculated data INTO a table

Let's try adding the spa to the facilities table again. 
This time, though, we want to automatically generate the value for the next facid,
rather than specifying it as a constant. Use the following VALUES for everything else:

Name: 'Spa', membercost: 20, guestcost: 30, initialoutlay: 100000, monthlymaintenance: 800.
*/
INSERT INTO cd.facilities
(facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
SELECT (SELECT max(facid) FROM cd.facilities)+1, 'Spa', 20, 30, 100000, 800;   


-- UPDATING

/*
4
We made a mistake when entering the data for the second tennis court. 
The initial outlay was 10000 rather than 8000: you need to alter the data to fix the error.
*/
UPDATE cd.facilities
SET initialoutlay = 10000
WHERE facid = 1;  

/*
5
Update multiple rows and columns at the same time

We want to increase the price of the tennis courts for both members and guests.
Update the costs to be 6 for members, and 30 for guests.
*/
UPDATE cd.facilities
SET membercost = 6, guestcost = 30
WHERE facid IN (0,1);  

/*
6
Update a row based on the contents of another row

We want to alter the price of the second tennis court so that it costs 10% more than the first one.
Try to do this without using constant VALUES for the prices, so that we can reuse the statement if we want to.
*/

UPDATE cd.facilities facs
SET membercost = (SELECT membercost * 1.1 FROM cd.facilities WHERE facid = 0),
    guestcost = (SELECT guestcost * 1.1 FROM cd.facilities WHERE facid = 0)
WHERE facs.facid = 1;  


-- DELETING

/*
7
As part of a clearout of our database, we want to DELETE all bookings FROM the cd.bookings table. How can we accomplish this?
*/
DELETE FROM cd.bookings;   

ALTERNATIVELY

TRUNCATE cd.bookings;

/*
8
Delete a member FROM the cd.members table
*/
DELETE FROM cd.members WHERE memid = 37;  

/*
9
Delete based on a subquery

Delete all members who have never made a booking
*/
DELETE FROM cd.members 
WHERE memid NOT IN (SELECT memid FROM cd.bookings);

