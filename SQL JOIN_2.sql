CREATE TABLE IF NOT EXISTS EMPDETAILS (
ID INT,
Name VARCHAR (50),
Salary INT );

INSERT INTO EMPDETAILS  VALUES (1,'John',40000);
INSERT INTO EMPDETAILS  VALUES (2,'Alex',25000);
INSERT INTO EMPDETAILS  VALUES (3,'Simon',43000);

SELECT * FROM EMPDETAILS;

CREATE TABLE IF NOT EXISTS MaritalStatus (
ID INT,
Name VARCHAR (50),
Status Varchar(30));

INSERT INTO MaritalStatus VALUES (1,'John','Married');
INSERT INTO MaritalStatus VALUES (3,'Simon','Married');
INSERT INTO MaritalStatus VALUES (4,'Stella','Unmarried');

SELECT * FROM MARITALSTATUS;

-- LEFT JOIN --
SELECT e.ID,e.Name,e.Salary,m.STATUS FROM EMPDETAILS e LEFT JOIN MARITALSTATUS m ON e.ID = m.id; 

-- RIGHT JOIN --
SELECT e.ID,e.Name,e.Salary,m.STATUS FROM EMPDETAILS e RIGHT JOIN MARITALSTATUS m ON e.ID = m.id; 

-- INNER JOIN --
SELECT e.ID,e.Name,e.Salary,m.STATUS FROM EMPDETAILS e INNER JOIN MARITALSTATUS m ON e.ID = m.id; 

-- FULL JOIN -- 
SELECT e.ID,e.Name,e.Salary,m.STATUS FROM EMPDETAILS e LEFT JOIN MARITALSTATUS m ON e.ID = m.id
UNION
SELECT e.ID,e.Name,e.Salary,m.STATUS FROM EMPDETAILS e RIGHT JOIN MARITALSTATUS m ON e.ID = m.id; 

CREATE TABLE IF NOT EXISTS STUDENT_TABLE (
StudentID INT,
StudentName VARCHAR (30),
FatherName VARCHAR (30),
Course ENUM ('Engineering' ,'Pharmacy','Management','Medical','B.Pharma','Graduation')
);

CREATE TABLE IF NOT EXISTS COLLEGE (
StudentID INT,
CollegeID INT,
CollegeName VARCHAR (100)
);

INSERT INTO STUDENT_TABLE VALUES (1,'Liam Mason','Noah ELijah','Engineering');
INSERT INTO STUDENT_TABLE VALUES (2,'William James','Logan Benjamin','Pharmacy');
INSERT INTO STUDENT_TABLE VALUES (3,'Oliver Lucas','Jacob Michael','Management');
INSERT INTO STUDENT_TABLE VALUES (4,'Alexander Daniel','Ethan Matthew','Medical');
INSERT INTO STUDENT_TABLE VALUES (5,'Aiden Henry','Joseph Jackson','Engineering');
INSERT INTO STUDENT_TABLE VALUES (6,'Samuel Carter','David Sebastian','B.Pharma');
INSERT INTO STUDENT_TABLE VALUES (7,'Jayden','John','Pharmacy');
INSERT INTO STUDENT_TABLE VALUES (8,'Owen Dylan','Luke Gabriel','Management');
INSERT INTO STUDENT_TABLE VALUES (9,'Anthony Isaac','Grayson Jack','Engineering');
INSERT INTO STUDENT_TABLE VALUES (10,'Julian Levi','Joshua Andrew','B.Pharma');
INSERT INTO STUDENT_TABLE VALUES (11,'Lincoln Mateo','Ryan Nathan','Medical');
INSERT INTO STUDENT_TABLE VALUES (12,'Aaron','Isaiah','Graduation');
INSERT INTO STUDENT_TABLE VALUES (13,'Thomas Charles','Caleb Josiah','Pharmacy');
INSERT INTO STUDENT_TABLE VALUES (14,'Christian Hunter','Jonathan Connor','Graduation');
INSERT INTO STUDENT_TABLE VALUES (15,'Landon Nolan','Nicholas Ezra','Medical');

INSERT INTO COLLEGE VALUES (1,11,'Stanford University');
INSERT INTO COLLEGE VALUES (2,12,'Yale University');
INSERT INTO COLLEGE VALUES (3,13,'Columbia University');
INSERT INTO COLLEGE VALUES (4,11,'Stanford University');
INSERT INTO COLLEGE VALUES (5,13,'Columbia University');
INSERT INTO COLLEGE VALUES (6,17,'University of The West');
INSERT INTO COLLEGE VALUES (7,18,"Saint Peter's University");
INSERT INTO COLLEGE VALUES (10,19,'Duke University');
INSERT INTO COLLEGE VALUES (12,18,"Saint Peter's University");
INSERT INTO COLLEGE VALUES (15,12,'Yale University');

SELECT * FROM STUDENT_TABLE;
SELECT * FROM COLLEGE;

-- INNER JOIN --
SELECT s.StudentID,s.StudentName,s.FatherName,S.Course,C.CollegeID,C.CollegeName FROM STUDENT_TABLE s 
INNER JOIN College C ON s.StudentID = C.StudentID;

-- LEFT JOIN --
SELECT s.StudentID,s.StudentName,s.FatherName,S.Course,C.CollegeID,C.CollegeName FROM STUDENT_TABLE s 
LEFT JOIN College C ON s.StudentID = C.StudentID;

-- RIGHT JOIN --
SELECT s.StudentID,s.StudentName,s.FatherName,S.Course,C.CollegeID,C.CollegeName FROM STUDENT_TABLE s 
RIGHT JOIN College C ON s.StudentID = C.StudentID;

-- Full Outer JOIN --
SELECT s.StudentID,s.StudentName,s.FatherName,S.Course,C.CollegeID,C.CollegeName FROM STUDENT_TABLE s 
LEFT JOIN College C ON s.StudentID = C.StudentID
UNION
SELECT s.StudentID,s.StudentName,s.FatherName,S.Course,C.CollegeID,C.CollegeName FROM STUDENT_TABLE s 
RIGHT JOIN College C ON s.StudentID = C.StudentID;