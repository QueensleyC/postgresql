/*
1
Output the names of all members, formatted AS 'Surname, Firstname'
*/
SELECT CONCAT(surname, ', ' ,firstname) AS name
FROM cd.members

/*
2
Find all facilities whose name begins with 'Tennis'
*/
SELECT * 
FROM cd.facilities WHERE name LIKE 'Tennis%';   

/*
3
Perform a case-insensitive search to find all facilities whose name begins with 'tennis'. 
Retrieve all columns.
*/
SELECT * 
FROM cd.facilities WHERE name ILIKE 'TENNIS%'; 

/*
4
Find telephone numbers with parentheses
*/
SELECT memid, telephone 
FROM cd.members WHERE telephone ~ '[()]';

/*
5
Pad zip codes with leading zeroes
*/
SELECT lpad(CAST(zipcode AS char(5)),5,'0') zip 
FROM cd.members ORDER BY  zip

/*
6
Count the number of members whose surname starts with each letter of the alphabet
*/
SELECT substr (mems.surname,1,1) AS letter, COUNT(*) AS count 
FROM cd.members mems
GROUP BY  letter
ORDER BY  letter 

/*
7
The telephone numbers in the database are very inconsistently formatted.
You'd LIKE to print a list of member ids and numbers that have had 
'-','(',')', and ' ' characters removed. ORDER BY  member id.
*/
SELECT memid, translate(telephone, '-() ', '') AS telephone
FROM cd.members
ORDER BY  memid