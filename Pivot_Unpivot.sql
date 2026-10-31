CREATE DATABASE PIVOT_UNPIVOT;
USE PIVOT_UNPIVOT;

CREATE TABLE sales (
	id INT AUTO_INCREMENT PRIMARY KEY,
    product VARCHAR(50),
    month VARCHAR(10),
    amount INT
);

INSERT INTO sales (product,month,amount) VALUES
('Apple', 'Jan', 100),
('Apple', 'Feb', 150),
('Apple', 'Mar', 200),
('Orange', 'Jan', 120),
('Orange', 'Feb', 200),
('Orange', 'Mar', 180),
('Banana', 'Jan', 90),
('Banana', 'Feb', 110),
('Banana', 'Mar', 130),
('Grapes', 'Jan', 160),
('Grapes', 'Feb', 170),
('Grapes', 'Mar', 190);

SELECT * FROM sales;
# Static Pivot: Products Vs. Months

SELECT Product,
SUM(CASE WHEN month = 'Jan' THEN amount ELSE 0 END) AS Jan,
SUM(CASE WHEN month = 'Feb' THEN amount ELSE 0 END) AS Feb,
SUM(CASE WHEN month = 'Mar' THEN amount ELSE 0 END) AS Mar
FROM sales
GROUP BY product;

# Static Pivot: Products As Columns

Select Month,
SUM(CASE WHEN product = 'Apple' THEN amount ELSE 0 END) AS Apple,
SUM(CASE WHEN product = 'Orange' THEN amount ELSE 0 END) AS Orange,
SUM(CASE WHEN product = 'Banana' THEN amount ELSE 0 END) AS Banana,
SUM(CASE WHEN product = 'Grapes' THEN amount ELSE 0 END) AS Grapes
FROM sales
GROUP BY month;

CREATE TABLE Sales_data (
	Year INT,
    Quarter VARCHAR(2),
    Amount int
);

INSERT INTO Sales_data (Year,Quarter, Amount) VALUES
(2023, 'Q1', 1000),
(2023, 'Q2', 1500),
(2023, 'Q3', 1200),
(2023, 'Q4', 1700),
(2024, 'Q1', 1100),
(2024, 'Q2', 1600),
(2024, 'Q3', 1300),
(2024, 'Q4', 1800);

SELECT * FROM sales_data;

SELECT Year,
	SUM(CASE WHEN Quarter = 'Q1' THEN AMOUNT ELSE 0 END) AS Q1,
	SUM(CASE WHEN Quarter = 'Q2' THEN AMOUNT ELSE 0 END) AS Q2,
	SUM(CASE WHEN Quarter = 'Q3' THEN AMOUNT ELSE 0 END) AS Q3,
	SUM(CASE WHEN Quarter = 'Q4' THEN AMOUNT ELSE 0 END) AS Q4
FROM Sales_data
GROUP BY Year
ORDER BY Year;

SELECT Quarter,
	SUM(CASE WHEN Year = 2023 THEN AMOUNT ELSE 0 END) AS `2023`,
    SUM(CASE WHEN Year = 2024 THEN AMOUNT ELSE 0 END) AS `2024`
FROM sales_data
GROUP BY Quarter;

## REVERSE / UNPIVOT ##

WITH PivotedSales AS (
	SELECT Year,
	SUM(CASE WHEN Quarter = 'Q1' THEN AMOUNT ELSE 0 END) AS Q1,
	SUM(CASE WHEN Quarter = 'Q2' THEN AMOUNT ELSE 0 END) AS Q2,
	SUM(CASE WHEN Quarter = 'Q3' THEN AMOUNT ELSE 0 END) AS Q3,
	SUM(CASE WHEN Quarter = 'Q4' THEN AMOUNT ELSE 0 END) AS Q4
FROM Sales_data
GROUP BY Year
)
SELECT Year, 'Q1' AS Quarter, Q1 As Amount FROM PivotedSales
UNION ALL
SELECT Year, 'Q2', Q2 FROM PivotedSales
UNION ALL
SELECT Year, 'Q3', Q3 FROM PivotedSales
UNION ALL
SELECT Year, 'Q4', Q4 FROM PivotedSales
ORDER BY Year, Quarter;

## -- Pivot by Department & Year -- ##
CREATE TABLE Employee_Salary (
	EmpName VARCHAR(50),
    Dept VARCHAR(20),
    Year INT,
    Salary INT 
);

INSERT INTO Employee_Salary VALUES
('Alice','HR', 2023, 50000),
('Bob','Finance', 2023, 60000),
('Charlie','IT', 2023, 70000),
('David','HR', 2024, 52000),
('Eva','Finance', 2024, 61000),
('Frank','IT', 2024, 72000);

SELECT * FROM Employee_Salary;

SELECT YEAR,
	SUM(CASE WHEN DEPT = 'HR' THEN Salary ELSE 0 END) AS HR,
    SUM(CASE WHEN DEPT = 'Finance' THEN Salary ELSE 0 END) AS Finance,
    SUM(CASE WHEN DEPT = 'IT' THEN Salary ELSE 0 END) AS IT
FROM Employee_Salary
GROUP BY Year
Order BY Year;

SELECT Dept,
	SUM(CASE WHEN Year = 2023 THEN Salary ELSE 0 END) AS '2023',
    SUM(CASE WHEN Year = 2024 THEN Salary ELSE 0 END) AS '2024'
FROM Employee_Salary
GROUP BY Dept;

## Unpivot Back ##
WITH Pivoted AS (
SELECT YEAR,
	SUM(CASE WHEN DEPT = 'HR' THEN Salary ELSE 0 END) AS HR,
    SUM(CASE WHEN DEPT = 'Finance' THEN Salary ELSE 0 END) AS Finance,
    SUM(CASE WHEN DEPT = 'IT' THEN Salary ELSE 0 END) AS IT
FROM Employee_Salary
GROUP BY Year
Order BY Year
)
SELECT Year, 'HR' AS Dept, HR AS Salary FROM Pivoted
UNION ALL
SELECT Year,'Finance', Finance FROM Pivoted
UNION ALL
SELECT Year, 'IT', IT FROM Pivoted
ORDER BY Year, Dept;