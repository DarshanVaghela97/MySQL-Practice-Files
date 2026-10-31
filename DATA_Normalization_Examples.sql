CREATE DATABASE Normalization;
USE Normalization;

-- Unnomalized Table 
CREATE TABLE Employee_UNF (
	EmpID INT,
    EmpName VARCHAR(50),
    DeptName VARCHAR(50),
    DeptLocation VARCHAR(50),
    Skill VARCHAR(50)
);

INSERT INTO Employee_UNF VALUES
(1,'Amit','IT','Mumbai','Python,SQL'),
(2,'Neha','HR','Delhi','Recruitment');

SELECT * FROM Employee_UNF;

-- Problems :
-- Skills column has multiple values (not atomic)
    -- DeptLocation depends on DeptName (transitive dependency)

-- 1NF (Atomic Values)
CREATE TABLE Employee_1NF (
    EmpID INT,
    EmpName VARCHAR(50),
    DeptName VARCHAR(50),
    DeptLocation VARCHAR(50),
    Skill VARCHAR(50)
);

INSERT INTO Employee_1NF VALUES
(1, 'Amit', 'IT', 'Mumbai', 'Python'),
(1, 'Amit', 'IT', 'Mumbai', 'SQL'),
(2, 'Neha', 'HR', 'Delhi', 'Recruitment');

SELECT * FROM Employee_1NF;

-- 2NF (Remove Partial Dependency)
-- Primary Key = (EmpID, Skill)
-- EmpName depends only on EmpID → split table.

CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50),
    DeptName VARCHAR(50)
);

INSERT INTO Employees VALUES
(1, 'Amit', 'IT'),
(2, 'Neha', 'HR');

SELECT * FROM Employees;

CREATE TABLE EmployeeSkills (
    EmpID INT,
    Skill VARCHAR(50),
    PRIMARY KEY (EmpID, Skill),
    FOREIGN KEY (EmpID) REFERENCES Employees(EmpID)
);

INSERT INTO EmployeeSkills
VALUES
(1, 'Python'),
(1, 'SQL'),
(2, 'Recruitment');

SELECT * FROM EmployeeSkills;

-- 3NF (Remove Transitive Dependency)
-- DeptLocation depends on DeptName → separate table.

CREATE TABLE Departments (
    DeptName VARCHAR(50) PRIMARY KEY,
    DeptLocation VARCHAR(50)
);

INSERT INTO Departments VALUES
('IT', 'Mumbai'),
('HR', 'Delhi');

SELECT * FROM Departments;

-- Real Company Example
CREATE TABLE Orders_UNF (
    OrderID INT,
    CustomerName VARCHAR(50),
    CustomerCity VARCHAR(50),
    ProductName VARCHAR(50),
    ProductPrice DECIMAL(10,2)
);

INSERT INTO Orders_UNF VALUES
(1, 'Rahul', 'Ahmedabad', 'Laptop', 60000),
(1, 'Rahul', 'Ahmedabad', 'Mouse', 500),
(2, 'Priya', 'Surat', 'Keyboard', 1500);

SELECT * FROM Orders_UNF;

-- Problems:
    -- CustomerCity depends on CustomerName
    -- ProductPrice depends on ProductName

-- 3NF Structure
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    CustomerCity VARCHAR(50)
);

INSERT INTO Customers VALUES
(1, 'Rahul', 'Ahmedabad'),
(2, 'Priya', 'Surat');

SELECT * FROM Customers;

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    ProductPrice DECIMAL(10,2)
);

INSERT INTO Products VALUES
(101, 'Laptop', 60000),
(102, 'Mouse', 500),
(103, 'Keyboard', 1500);

SELECT * FROM Products;

CREATE TABLE Orders (
    OrderID INT,
    CustomerID INT,
    ProductID INT,
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Orders VALUES
(1, 1, 101),
(1, 1, 102),
(2, 2, 103);

SELECT * FROM Orders;

-- BCNF (Boyce-Codd Normal Form) with Example
-- Rule:
    -- For every functional dependency
    -- X → Y, X must be a super key.

-- Table (Not BCNF)
CREATE TABLE Class (
    StudentID INT,
    Subject VARCHAR(50),
    Teacher VARCHAR(50)
);

-- Assume:
    -- Each subject has only one teacher.
    -- Primary Key = (StudentID, Subject)

INSERT INTO Class VALUES
(1, 'Math', 'Sharma'),
(2, 'Math', 'Sharma'),
(1, 'English', 'Mehta');

SELECT * FROM Class;

-- Problem:
    -- Subject → Teacher
    -- But Subject is NOT a super key.
    -- So violates BCNF.
-- Convert to BCNF
CREATE TABLE Subjects (
    Subject VARCHAR(50) PRIMARY KEY,
    Teacher VARCHAR(50)
);

INSERT INTO Subjects VALUES
('Math', 'Sharma'),
('English', 'Mehta');

SELECT * FROM Subjects;

CREATE TABLE Student_Subject (
    StudentID INT,
    Subject VARCHAR(50),
    PRIMARY KEY (StudentID, Subject),
    FOREIGN KEY (Subject) REFERENCES Subjects(Subject)
);

INSERT INTO Student_Subject VALUES
(1, 'Math'),
(2, 'Math'),
(1, 'English');

SELECT * FROM Student_Subject;

-- Now:
    -- Every determinant is a super key
    -- This is BCNF

-- Help in Interview
-- 1NF → Atomic values
-- 2NF → No partial dependency
-- 3NF → No transitive dependency
-- BCNF → Every determinant must be super key