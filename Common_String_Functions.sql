-- String Functions 
USE Sakila;

-- Length : Gives the length of string including spaces
SELECT LENGTH('Skyfall');

SELECT First_name,Length(First_name) FROM Customer;

SELECT Upper('Skyfall');
SELECT Lower('SKYFALL');

-- TRIM removes spaces from left and right, Ltrim for left side spaces and RTrim for right side spaces 


SELECT TRIM('         SKY           ');
SELECT LTRIM('         SKY           ');
SELECT RTRIM('         SKY           ');

SELECT First_name,LEFT(First_name,4) FROM Customer; -- Gives first four characters of first name from left --
SELECT First_name,Right(First_name,4) FROM Customer; -- Gives first four characters of first name from Right --

SELECT First_Name,
LEFT(First_name,4),
RIGHT(First_name,4),
SUBSTRING(First_name,3,2)
FROM Customer;

-- Substring('string',start_position,no.of_characters) --

-- REPLACE (It replaces characters with what we specify) --
SELECT First_name,REPLACE(First_name,'I','@@@') FROM customer;

-- LOCATE --
SELECT LOCATE('h', 'Darshan');

-- CONCAT --
SELECT First_name,Last_Name,CONCAT(First_Name,' ',Last_Name) AS FULL_NAME FROM Customer;


-- CONCAT(): Combines multiple strings into one (e.g., full names).
-- LENGTH(): Returns the length of a string (e.g., checking password length).
-- LOWER()/UPPER(): Converts a string to lowercase or uppercase (e.g., email validation).
-- SUBSTRING(): Extracts part of a string (e.g., area codes).
-- TRIM(): Removes extra spaces (e.g., cleaning user input).
-- REPLACE(): Replaces occurrences of a substring (e.g., updating city names).