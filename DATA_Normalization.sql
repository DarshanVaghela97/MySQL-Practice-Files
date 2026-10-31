CREATE DATABASE Normalization;
USE Normalization;

# What is normalization?
-- Normalization is the process of organizing data into tables to reduce redundancy and improve data integrity. 
-- 1NF, 2NF, 3NF

-- 1NF (First Normal Form - Atomic Values)
-- Rules:
	-- No repeating Groups
    -- No multiple values in One column
    -- Each Column must contain atomic (single) values

CREATE TABLE StudentCourse_1NF (
	StudentId INT,
    StudentName Varchar(50),
    CourseName Varchar(50),
    Instructor Varchar(50),
    InstructorPhone Varchar(15)
); 

INSERT INTO StudentCourse_1NF VALUES
(101,'Rahul','Math','Sharma','9876543210'),
(101,'Rahul','Science','Sharma','9876543210'),
(102,'Priya','English','Mehta','9123456780');

Select * FROM StudentCourse_1NF;

-- 2NF (Second Normal Form - Remove Partial Dependency_
-- Rule :
	-- Must be in 1NF
    -- No Partial Dependency
    -- Every non-key column must depend on the whole primary key
    
-- Primary Key Here = (studentID, CourseName)
-- Problem
	-- StudentName depends only on StudentID
    -- Instructor depends only on CourseName
-- Split tables :

CREATE TABLE students (
	StudentID INT PRIMARY KEY,
    StudentName VARCHAR(50)
);

INSERT INTO Students VALUES
(101,'Rahul'),
(102,'Priya');

SELECT * FROM Students;

CREATE TABLE Courses (
	CourseName VARCHAR(50) PRIMARY KEY,
    Instructor VARCHAR(50),
    InstructorPhone VARCHAR(15)
);

INSERT INTO Courses VALUES
('Math','Sharma','9876543210'),
('Science','Sharma','9876543210'),
('English','Mehta','9123456780');

SELECT * FROM Courses;

-- Enrollments table (Many-to-Many relationship)
CREATE TABLE Student_Course (
	StudentID INT,
    CourseName VARCHAR(50),
    PRIMARY KEY (StudentID, CourseName),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseName) REFERENCES Courses(CourseName)
);

INSERT INTO Student_Course VALUES
(101,'Math'),
(101,'Science'),
(102,'English');

-- 3NF (Third Normal Form Remove Transitive Dependency)
-- Rule :
	-- InstructorPhone depends on Instructor
    -- Instructor depends on CourseName
		-- Transitive dependency
        
-- separate Instructor table.
CREATE TABLE Instructors (
	InstructorID INT PRIMARY KEY,
    InstructorName VARCHAR(50),
    InstructorPhone VARCHAR(15)
);

INSERT INTO Instructors VALUES
(1, 'Sharma', '9876543210'),
(2,'Mehta','9123456780');

SELECT * FROM Instructors;

-- Updated Courses Table
CREATE TABLE Courses_3NF (
	CourseName VARCHAR(50) PRIMARY KEY,
    InstructorID INT,
    FOREIGN KEY (InstructorID) REFERENCES Instructors(InstructorID)
);

INSERT INTO Courses_3NF VALUES
('Math',1),
('Science',1),
('English',2);

SELECT * FROM Courses_3NF;

-- Students Table (same as 2NF)
CREATE TABLE Students_3NF (
	StudentID INT PRIMARY KEY,
    StudentName VARCHAR(50)
);

INSERT INTO Students_3NF VALUES
(101,'Rahul'),
(102,'Priya');

SELECT * FROM Students_3NF;

-- Student_Course Mapping
CREATE TABLE Student_Course_3NF (
	StudentID INT,
    CourseName VARCHAR(50),
    PRIMARY KEY (StudentID, CourseName),
    FOREIGN KEY (StudentID) References Students_3NF(StudentID),
    FOREIGN Key (CourseName) References Courses_3NF(CourseName)
);

INSERT INTO Student_Course_3NF VALUES
(101,'Math'),
(101,'Science'),
(102,'English');

SELECT * FROM Student_Course_3NF;