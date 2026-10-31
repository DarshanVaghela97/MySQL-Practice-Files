CREATE DATABASE Window_Func_Assignment;
USE Window_Func_Assignment;

CREATE TABLE IF NOT EXISTS Employee_Sales (
Emp_ID INT,
Emp_Name VARCHAR(20),
Dept Enum('HR','IT','Finance'),
`Month` Enum('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'),
Amount INT
);

INSERT INTO Employee_Sales VALUES 
(1, 'Alice', 'HR', 'Jan', 5000),
(2, 'Bob', 'HR', 'Jan', 7000),
(3, 'Charlie', 'IT', 'Jan', 8000),
(4, 'David', 'IT', 'Jan', 6500),
(5, 'Eva', 'Finance', 'Jan', 9000),
(1, 'Alice', 'HR', 'Feb', 6000),
(2, 'Bob', 'HR', 'Feb', 7500),
(3, 'Charlie', 'IT', 'Feb', 8200),
(4, 'David', 'IT', 'Feb', 7000),
(5, 'Eva', 'Finance', 'Feb', 9500),
(1, 'Alice', 'HR', 'Mar', 5500),
(2, 'Bob', 'HR', 'Mar', 7200),
(3, 'Charlie', 'IT', 'Mar', 8700),
(4, 'David', 'IT', 'Mar', 6800),
(5, 'Eva', 'Finance', 'Mar', 9100);

SELECT * FROM Employee_Sales;

-- 1. Assign a unique row number to each record ordered by sales_amount (highest first). --
SELECT Emp_ID, EMP_NAME, DEPT, Month, Amount,
ROW_NUMBER() OVER(ORDER BY AMOUNT DESC) AS ROW_NUM
FROM EMPLOYEE_SALES;

-- 2. For each department, generate a row number ordered by sales_amount.--
SELECT Emp_ID, EMP_NAME, DEPT, Month, Amount,
ROW_NUMBER() OVER(PARTITION BY DEPT ORDER BY AMOUNT DESC) AS ROW_NUM
FROM EMPLOYEE_SALES;

-- 3. Show the top 2 employees per department per month using ROW_NUMBER(). --
SELECT * FROM (
SELECT Emp_ID, EMP_NAME, DEPT, Month, Amount,
ROW_NUMBER() OVER(PARTITION BY DEPT,MONTH ORDER BY AMOUNT DESC) AS ROW_NUM
FROM EMPLOYEE_SALES
) AS RANKED
WHERE ROW_NUM <= 2;

-- 4. Rank employees by sales_amount (highest first) in each month. --
SELECT Emp_ID, EMP_NAME, DEPT, Month, Amount,
RANK () OVER(PARTITION BY MONTH ORDER BY AMOUNT DESC) AS ROW_RANK
FROM EMPLOYEE_SALES;

-- 5. Rank employees by sales_amount across all months. --
SELECT Emp_ID, EMP_NAME, DEPT, Month, Amount,
RANK () OVER(ORDER BY AMOUNT DESC) AS ROW_RANK
FROM EMPLOYEE_SALES;

-- 6. Find employees who share the same rank in a department. --

-- 7. Assign dense rank to employees per department by sales_amount. --
SELECT  Emp_ID, EMP_NAME, DEPT, Month, Amount,
DENSE_RANK () OVER(PARTITION BY DEPT ORDER BY AMOUNT DESC) AS DENSE_RANKING
FROM EMPLOYEE_SALES;

-- 8. Compare results of RANK() vs DENSE_RANK() when there are ties.--
SELECT  Emp_ID, EMP_NAME, DEPT, Month, Amount,
RANK () OVER(ORDER BY AMOUNT DESC) AS ROW_RANK,
DENSE_RANK () OVER(ORDER BY AMOUNT DESC) AS DENSE_RANKING
FROM EMPLOYEE_SALES;

-- 9. Find the top 2 ranked employees per department per month using DENSE_RANK(). --
SELECT * FROM (
SELECT  Emp_ID, EMP_NAME, DEPT, Month, Amount,
DENSE_RANK () OVER(PARTITION BY DEPT ORDER BY AMOUNT DESC) AS DENSE_RANKING
FROM EMPLOYEE_SALES
) AS DENSE_RANKED
WHERE DENSE_RANKING <=2;

-- 10. Show each employee’s sales and next month’s sales using LEAD(). --
SELECT  Emp_ID, EMP_NAME, DEPT, Month, Amount,
LEAD(Amount,1) OVER(PARTITION BY Emp_Name ORDER BY MONTH) AS Next_Month_Amount
FROM EMPLOYEE_SALES;

-- 11. Calculate the growth in sales compared to next month. --
SELECT  Emp_ID, EMP_NAME, DEPT, Month, Amount,
LEAD(Amount,1) OVER(PARTITION BY Emp_Name ORDER BY MONTH) AS Next_Month_Amount,
LEAD(Amount,1) OVER(PARTITION BY Emp_Name ORDER BY MONTH) - Amount AS Growth
FROM EMPLOYEE_SALES;

-- 12. Identify employees whose sales are decreasing compared to the next month. --
SELECT * FROM
(
SELECT Emp_ID, EMP_NAME, DEPT, Month, Amount,
LEAD(Amount,1) OVER(PARTITION BY Emp_Name ORDER BY MONTH) AS Next_Month_Amount,
LEAD(Amount,1) OVER(PARTITION BY Emp_Name ORDER BY MONTH) - Amount AS Growth
FROM EMPLOYEE_SALES
) AS New_Table
WHERE Growth < 0;


-- 13. Show each employee’s sales and previous month’s sales using LAG().
SELECT  Emp_ID, EMP_NAME, DEPT, Month, Amount,
LAG(Amount,1) OVER(PARTITION BY Emp_Name ORDER BY MONTH) AS Previous_Month_Amount
FROM EMPLOYEE_SALES;

-- 14. Calculate the difference between current and previous month sales. --
SELECT  Emp_ID, EMP_NAME, DEPT, Month, Amount,
LAG(Amount,1) OVER(PARTITION BY Emp_Name ORDER BY MONTH) AS Previous_Month_Amount,
Amount - LAG(Amount,1) OVER(PARTITION BY Emp_Name ORDER BY Amount) AS Difference
FROM EMPLOYEE_SALES;

-- 15. Find employees whose sales increased compared to the previous month. --
SELECT * FROM
(
SELECT Emp_ID, EMP_NAME, DEPT, Month, Amount,
LAG(Amount,1) OVER(PARTITION BY Emp_Name ORDER BY MONTH) AS Previous_Month_Amount,
Amount -  LAG(Amount,1) OVER(PARTITION BY Emp_Name ORDER BY MONTH) AS Difference
FROM EMPLOYEE_SALES
) AS New_Table
WHERE Difference > 0;

-- 16. Use ROW_NUMBER() to find the highest sales record for each employee. --
SELECT * FROM (
SELECT Emp_ID, EMP_NAME, DEPT, Month, Amount,
ROW_NUMBER() OVER(PARTITION BY EMP_NAME ORDER BY AMOUNT DESC) AS ROW_NUM
FROM EMPLOYEE_SALES) AS NEW_TABLE
WHERE ROW_NUM =1;

-- 17. Use RANK() to get the top 3 sales across all employees. --
SELECT * FROM (
SELECT Emp_ID, EMP_NAME, DEPT, Month, Amount,
RANK() OVER(ORDER BY AMOUNT DESC) AS RANK_NUM
FROM EMPLOYEE_SALES ) AS NEW_TABLE
LIMIT 3;

-- 18. Use DENSE_RANK() to get the top 2 sales per department ignoring gaps. --
SELECT * FROM (
SELECT Emp_ID, EMP_NAME, DEPT, Month, Amount,
DENSE_RANK() OVER(PARTITION BY DEPT ORDER BY AMOUNT DESC) AS RANK_NUM
FROM EMPLOYEE_SALES) AS NEW_TABLE
WHERE RANK_NUM <=2;

-- 19. Use LEAD() + LAG() together to show previous, current, and next month sales for each employee. --
SELECT Emp_ID, EMP_NAME, DEPT, Month, Amount AS Current_Month_Sales,
LEAD(Amount,1) OVER(PARTITION BY EMP_NAME ORDER BY MONTH) AS Next_Month_Sales,
LAG(Amount,1) OVER(PARTITION BY EMP_NAME ORDER BY MONTH) AS Previous_Month_Sales
FROM EMPLOYEE_SALES;

-- IF DON'T WANT TO SEE NULL --
SELECT * FROM (
SELECT Emp_ID, EMP_NAME, DEPT, Month, Amount AS Current_Month_Sales,
LEAD(Amount,1) OVER(PARTITION BY EMP_NAME ORDER BY MONTH) AS Next_Month_Sales,
LAG(Amount,1) OVER(PARTITION BY EMP_NAME ORDER BY MONTH) AS Previous_Month_Sales
FROM EMPLOYEE_SALES ) AS NEW_TABLE
WHERE Next_Month_Sales IS NOT NULL AND Previous_Month_Sales IS NOT NULL;

-- 20. Create a report showing: employee name, department, month, sales, previous month sales, next month sales, rank in department. --
SELECT Emp_Name, Dept, Month, Amount,
LAG(Amount,1) OVER(PARTITION BY EMP_NAME ORDER BY MONTH) AS Previous_Month_Sales,
LEAD(Amount,1) OVER(PARTITION BY EMP_NAME ORDER BY MONTH) AS Next_Month_Sales,
RANK() OVER(PARTITION BY DEPT ORDER BY AMOUNT DESC) AS RANKING
FROM EMPLOYEE_SALES;