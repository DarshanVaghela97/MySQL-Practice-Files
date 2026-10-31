CREATE DATABASE CTE_Common_Table_Expressions;
USE CTE_Common_Table_Expressions;

										-- EXAMPLE - 1 --
CREATE TABLE SALES (
	SalesID INT,
    ProductID INT,
    Amount DECIMAL(10,2)
);

INSERT INTO Sales (SalesID, ProductID, Amount) VALUES
(1, 101, 500.00),
(2, 101, 300.00),
(3, 102, 200.00),
(4, 102, 400.00),
(5, 103, 150.00);

WITH TotalSales AS (
	SELECT
		ProductID,
        SUM(Amount) AS TotalAmount
        FROM sales
        GROUP BY ProductId
)
SELECT 
	ProductID,
	TotalAmount
FROM TotalSales
WHERE TotalAmount > 400;

										-- EXAMPLE - 2 --
CREATE TABLE IF NOT EXISTS Employees (
	EmployeeID INT NOT NULL PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    ManagerID INT NULL
);

INSERT INTO Employees (EmployeeID, FirstName, LastName, ManagerID) VALUES
(1,'Ken','Thompson',NULL),
(2,'Terri','Ryan',1),
(3,'Robert','Durello',1),
(4,'Rob','Bailey',2),
(5,'Kent','Erickson',2),
(6,'Bill','Goldberg',3),
(7,'Ryan','Miller',3),
(8,'Dane','Mark',5),
(9,'Charles','Matthew',6),
(10,'Michael','Jhonson',6),
(11,'JOHN','DOI',4),
(12,'PEN','DOI',11);

SELECT * FROM Employees;

WITH RECURSIVE cteReports AS (
	-- Anchor member : Select the top-level managers (employees with no manager)
    SELECT
		EmployeeID AS EmpID,
        FirstName,
        LastName,
        ManagerID AS MgrID,
        1 AS EmpLevel
	FROM Employees
    WHERE ManagerID IS NULL
    UNION ALL
    -- Recursive member : Select employees who report to the employees in the previous level
    SELECT 
		e.EmployeeID,
        e.FirstName,
        e.LastName,
        e.ManagerID,
        r.EmpLevel + 1
	FROM Employees e
    INNER JOIN cteReports r ON e.ManagerID = r.EmpID
)
SELECT 
	CONCAT(cte.FirstName,' ',cte.LastName)AS FullName,
    cte.Emplevel,
    (SELECT CONCAT(m.FirstName,' ',m.LastName)
     FROM Employees m
     WHERE m.EmployeeID = cte.MgrID) AS Manager
FROM cteReports cte
ORDER BY cte.EmpLevel, cte.MgrID;

										-- EXAMPLE - 3 --
CREATE TABLE IF NOT EXISTS Categories (
	CategoryID INT NOT NULL PRIMARY KEY,
    CategoryName Varchar(50) NOT NULL,
    ParentCategoryID INT NULL
);

INSERT INTO Categories (CategoryID, CategoryName, ParentCategoryID) VALUES
(1,'Electronics',NULL),
(2,'Computers',1),
(3,'Laptops',2),
(4,'Desktops',2),
(5,'Smartphones',1),
(6,'Furniture',NULL),
(7,'Chairs',6),
(8,'Tables',6),
(9,'Mouse',2),
(10,'Power Bank',1),
(11,'Phone Cover',5);

WITH RECURSIVE CategoryHierarchy AS (
	-- Anchor member : Select top-level categories (categories with no parent)
    SELECT
		CategoryID,
        CategoryName,
        ParentCategoryID,
        1 AS CategoryLevel
	FROM Categories 
    WHERE ParentCategoryID IS NULL
	UNION ALL
	-- Recursive member :Select subcategories that belong to the previous level's categories
	SELECT
		c.CategoryID,
        c.CategoryName,
        c.ParentCategoryID,
        ch.CategoryLevel + 1
	FROM Categories c
    INNER JOIN CategoryHierarchy ch ON c.ParentCategoryID = ch.CategoryID
)
SELECT 
	CategoryID,
    CategoryName,
    CategoryLevel,
    (SELECT CategoryName FROM Categories WHERE CategoryID = ch.ParentCategoryID) AS ParentCategory
FROM CategoryHierarchy ch
ORDER BY CategoryLevel, ParentCategoryID;