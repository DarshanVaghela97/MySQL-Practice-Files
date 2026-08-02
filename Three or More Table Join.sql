-- LEFT JOIN - 1 to * - (One to Many)
-- RIGHT JOIN - * to 1 - (Many to One)
-- Inner JOIN - * to 1 - (One to One)
-- Full Join - * To * - (Many to Many)

-- SELECT
-- Column_Name(s)
-- FROM 
-- table1 -- The "one" side (LEFT TABLE)
-- LEFT JOIN
--     table2 -- The "many" side (RIGHT TABLE)
-- ON
--     table1.matching_column = table2.matching_column;

CREATE DATABASE JOINS;
USE JOINS;	

CREATE TABLE STUDENT(
s_id INT PRIMARY KEY,
s_name VARCHAR(20));

INSERT INTO STUDENT VALUES (1,'Jack');
INSERT INTO STUDENT VALUES (2,'Rithvik');
INSERT INTO STUDENT VALUES (3,'Jaspreet');
INSERT INTO STUDENT VALUES (4,'Praveen');
INSERT INTO STUDENT VALUES (5,'Bisa');
INSERT INTO STUDENT VALUES (6,'Suraj');

SELECT * FROM STUDENT;

CREATE TABLE MARKS(
School_id INT PRIMARY KEY,
S_id INT,
Score INT,
STATUS VARCHAR(20));

INSERT INTO MARKS VALUES(1004,1,23,'fail'),
(1008,6,95,'pass'),
(1012,2,97,'pass'),
(1016,7,67,'pass'),
(1020,3,100,'pass'),
(1025,8,73,'pass'),
(1030,4,88,'pass'),
(1035,9,13,'fail'),
(1040,5,16,'fail'),
(1050,10,53,'pass');

SELECT * FROM MARKS;

CREATE TABLE DETAILS(
address_city VARCHAR(20),
email_ID VARCHAR(20),
school_ID INT,
accomplishments varchar(50));

insert into details values ('Banglore', 'jsingh@geeks.com', 1020, 'ACM ICPC selected'); 
insert into details values('Hyderabad', 'praveen@geeks.com', 1030, 'Geek of the month'); 
insert into details values('Delhi', 'rithvik@geeks.com', 1012, 'IOI finalist'); 
insert into details values ('Chennai', 'om@geeks.com', 1111, 'Geek of the year'); 
insert into details values ('Banglore',' suraj@geeks.com', 1008, 'IMO finalist'); 
insert into details values ('Mumbai', 'sasukeh@geeks.com', 2211, 'Made a robot'); 
insert into details values ('Ahmedabad', 'itachi@geeks.com', 1172, 'Code Jam finalist'); 
insert into details values ('Jaipur', 'kumar@geeks.com', 1972, 'KVPY finalist');

SELECT * FROM DETAILS;

/* INNER JOIN */
SELECT s_name,score,status,address_city,email_id,accomplishments FROM student s
INNER JOIN marks m on s.s_id = m.s_id
INNER JOIN details d on d.school_id = m.school_id;

/* WHERE */
SELECT s_name, score, status, address_city, email_id,
accomplishments FROM student s, marks m, details d 
WHERE s.s_id = m.s_id AND m.school_id = d.school_id;

/* LEFT JOIN */
SELECT s.s_name, m.score, m.status, d.address_city, d.email_id, d.accomplishments
FROM STUDENT s 
LEFT JOIN marks m ON s.s_id = m.s_id
LEFT JOIN details d ON m.school_id = d.school_id; 

/* RIGHT JOIN */
SELECT s.s_name, m.score, m.status, d.address_city, d.email_id, d.accomplishments
FROM STUDENT s 
RIGHT JOIN marks m ON s.s_id = m.s_id
RIGHT JOIN details d ON m.school_id = d.school_id; 

/* FULL OUTER JOIN */
SELECT s.s_name, m.score, m.status, d.address_city, d.email_id, d.accomplishments
FROM STUDENT s 
LEFT JOIN marks m ON s.s_id = m.s_id
LEFT JOIN details d ON m.school_id = d.school_id
UNION
SELECT s.s_name, m.score, m.status, d.address_city, d.email_id, d.accomplishments
FROM STUDENT s 
RIGHT JOIN marks m ON s.s_id = m.s_id
RIGHT JOIN details d ON m.school_id = d.school_id; 

/* CROSS JOIN (Cartesian Product : every student x every mark) */
SELECT s.s_name, m.school_id, m.score, m.status
FROM STUDENT s
CROSS JOIN marks m;