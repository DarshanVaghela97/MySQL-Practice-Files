CREATE DATABASE CTE_Assignment;
USE CTE_Assignment;

CREATE TABLE IF NOT EXISTS Customers (
Customer_ID INT PRIMARY KEY,
Customer_Name Varchar (20),
City Varchar(30),
Year int
);

CREATE TABLE IF NOT EXISTS Orders (
Order_ID INT PRIMARY KEY,
Customer_ID INT,
Order_Date DATE,
Amount DECIMAL (10,2)
);

INSERT INTO Customers VALUES 
(1, 'Alice', 'New York', 2020),
(2, 'Bob', 'Los Angeles', 2021),
(3, 'Charlie', 'Chicago', 2020),
(4, 'David', 'Houston', 2022),
(5, 'Eva', 'Phoenix', 2021);

INSERT INTO Orders VALUES 
(101, 1, '2021-01-15', 250.00),
(102, 1, '2021-03-10', 450.00),
(103, 2, '2021-02-20', 300.00),
(104, 2, '2021-05-18', 700.00),
(105, 3, '2021-01-25', 150.00),
(106, 3, '2022-02-10', 500.00),
(107, 4, '2022-03-15', 600.00),
(108, 5, '2021-07-12', 400.00),
(109, 5, '2022-01-18', 800.00),
(110, 5, '2022-05-25', 1000.00);

SELECT * FROM Customers;
SELECT * FROM Orders;

-- 1. Write a CTE to get all customers who joined in 2021. --
WITH 2021_Customers AS (
SELECT * FROM Customers WHERE YEAR = 2021
)
SELECT Customer_Name,Year FROM 2021_Customers;

-- 2. Write a CTE to get all orders with amount > 500. --
WITH Order_MT_500 AS (
SELECT * FROM ORDERS WHERE Amount >500
)
SELECT Order_ID,Customer_ID,Amount FROM Order_MT_500;

SELECT Customer_ID,count(Order_ID) AS 'Total Orders' FROM Orders GROUP BY Customer_ID;

-- 3. Write a CTE to display customer names along with their total orders. --
WITH Order_Count AS (
SELECT Customer_ID,count(Order_ID) AS Total_Orders FROM Orders GROUP BY Customer_ID
)
Select C.Customer_name,O.Total_Orders FROM Order_Count O JOIN Customers C ON O.Customer_ID = C.Customer_ID;

-- 4. Write a CTE to list customers and their latest order date. --
WITH LASTEST_ORDER AS (
SELECT Customer_ID,max(order_date) AS Latest_Order_Date FROM Orders GROUP BY Customer_ID
)
Select C.Customer_name,L.Latest_Order_Date FROM LASTEST_ORDER L JOIN Customers C ON L.Customer_ID = C.Customer_ID;

-- 5. Write a CTE to calculate the average order amount per customer. --
With Average_Amount AS (
SELECT Customer_ID, Avg(Amount) AS Average_Order_Amt FROM Orders Customer_ID GROUP BY Customer_ID
)
SELECT A.Customer_ID,C.Customer_name,A.Average_Order_Amt FROM Average_Amount A JOIN Customers C ON A.Customer_ID = C.Customer_ID;

-- 6. Use a CTE to find the highest order amount per customer. --
WITH HIGHEST_ORDER AS (
SELECT Customer_ID,max(Amount) AS Max_Order_Amt FROM Orders GROUP BY Customer_ID
)
Select C.Customer_name,H.Max_Order_Amt FROM HIGHEST_ORDER H JOIN Customers C ON H.Customer_ID = C.Customer_ID;

-- 7. Use a CTE to calculate the total sales per year. --
WITH Order_Years AS (
    SELECT YEAR(order_date) AS `Year`, Amount
    FROM Orders
)
SELECT `Year`, SUM(Amount) AS Total_Sales
FROM Order_Years
GROUP BY `Year`;

-- 8. Use a CTE to get the customer with the maximum total order amount. --
With Order_Count AS (
SELECT Customer_ID,count(Order_ID) AS No_of_Orders FROM Orders GROUP BY Customer_ID
)
SELECT O.Customer_ID,C.Customer_Name,O.No_of_Orders FROM Order_Count O JOIN Customers C ON O.Customer_ID = C.Customer_ID;

-- 9. Write a CTE to list customers who spent more than 1000 in total. --
WITH Total_Amount AS (
    SELECT Customer_ID,sum(Amount) AS `Total Spending` FROM Orders GROUP BY Customer_ID
)
SELECT t.Customer_ID,C.Customer_Name,t.`Total Spending` FROM Total_Amount t 
JOIN Customers C ON T.Customer_ID = C.Customer_ID
WHERE t.`Total Spending` >= 1000;

-- 10. Write a CTE to find customers with more than 2 orders.
With Order_Count AS (
SELECT Customer_ID,count(Order_ID) AS No_of_Orders FROM Orders GROUP BY Customer_ID
)
SELECT O.Customer_ID,C.Customer_Name,O.No_of_Orders FROM Order_Count O 
JOIN Customers C ON O.Customer_ID = C.Customer_ID
Where O.No_of_Orders >=2;

-- 11. Create a CTE to join Customers and Orders, showing name, city, and order amount. --
With New_Table AS (
SELECT Customer_ID,Amount FROM Orders
)
SELECT C.Customer_Name,C.City,N.Amount FROM New_Table N
JOIN Customers C ON N.Customer_ID = C.Customer_ID;

-- 12. Write a CTE to find the total order amount per city. --
With New_Table AS (
SELECT Customer_ID,sum(amount) AS Total FROM Orders GROUP BY Customer_ID
)
SELECT C.City,SUM(N.Total) AS Total_Order_Amt FROM New_Table N 
JOIN Customers C ON N.Customer_ID = C.Customer_ID
GROUP BY City;
 
 -- 13. Use a CTE to get the list of customers who never placed an order.--
 With Order_Count AS (
SELECT Customer_ID,count(Order_ID) AS No_of_Orders FROM Orders GROUP BY Customer_ID
)
SELECT O.Customer_ID,C.Customer_Name,O.No_of_Orders FROM Order_Count O 
JOIN Customers C ON O.Customer_ID = C.Customer_ID
Where O.No_of_Orders = 0 ;

-- 14. Write a CTE to find customers who placed orders in 2022 only. --
WITH NEW_TABLE AS (
    SELECT Customer_ID,YEAR(order_date) AS `Year`
    FROM Orders
)
SELECT N.Customer_ID,C.Customer_Name,N.`Year` FROM NEW_TABLE N 
JOIN Customers C ON N.Customer_ID = C.Customer_ID
WHERE N.`Year`= 2022 ;

-- 15. Write a CTE to calculate each customer’s average order and rank them by spending. --
With New_Table AS (
SELECT Customer_ID,AVG(amount) AS Average_Amt FROM Orders GROUP BY Customer_ID
)
SELECT N.Customer_ID,C.Customer_Name,N.Average_Amt, 
RANK() OVER (ORDER BY N.Average_Amt DESC) AS Ranking
FROM New_Table N 
JOIN Customers C ON N.Customer_ID = C.Customer_ID;

-- 16. Write a recursive CTE to print numbers from 1 to 10. --
WITH RECURSIVE PrintNum AS (
	SELECT 1 AS `Number`
    UNION ALL
    SELECT `Number` + 1 From PrintNum WHERE `Number` < 10
)
SELECT * FROM PrintNum;

-- 17. Write a recursive CTE to calculate the factorial of 5. --
WITH RECURSIVE Factorial AS (
    SELECT 1 AS n, 1 AS fact
    UNION ALL
    SELECT n + 1, fact * (n + 1)
    FROM Factorial
    WHERE n < 5
)
SELECT * FROM Factorial;

-- 18. Write a recursive CTE to list all years from 2020 to 2025. --
WITH RECURSIVE YEARS AS (
	SELECT 2020 AS YEAR
    UNION ALL
    SELECT `YEAR` + 1 FROM YEARS WHERE `YEAR` < 2025
)
SELECT * FROM YEARS;

-- 19. Write a recursive CTE to generate a sequence of dates for January 2022. --
WITH RECURSIVE JAN2022 AS (
	SELECT DATE('2022-01-01') AS January
    UNION ALL
    SELECT DATE_ADD(January,INTERVAL 1 DAY) FROM JAN2022 WHERE January < '2022-01-31'
)
SELECT * FROM JAN2022;


-- 20. Write a recursive CTE to find the hierarchy of managers and employees (assume a Manager column in Customers as a self-reference). --
ALTER TABLE Customers 
ADD Column Manager_ID INT;

UPDATE Customers SET Manager_ID = NULL WHERE Customer_ID = 1;
UPDATE Customers SET Manager_ID = 1 WHERE Customer_ID IN (2,3);
UPDATE Customers SET Manager_ID = 2 WHERE Customer_ID IN (4,5);

SELECT * FROM Customers;

WITH RECURSIVE EmployeeLevel AS (
    SELECT 
        Customer_ID AS Emp_ID,
        Customer_Name AS Emp_Name,
        Manager_ID,
        1 AS EmpLevel
    FROM Customers WHERE Manager_ID IS NULL
    UNION ALL
    SELECT 
        C.Customer_ID AS Emp_ID,
        C.Customer_Name AS Emp_Name,
        C.Manager_ID,
        E.EmpLevel + 1
    FROM Customers C
    INNER JOIN EmployeeLevel E ON C.Manager_ID = E.Emp_ID
)
SELECT E.Emp_ID, E.Emp_Name, E.EmpLevel,
       (SELECT Customer_Name FROM Customers M WHERE M.Customer_ID = E.Manager_ID) AS Manager_Name
FROM EmployeeLevel E
ORDER BY E.EmpLevel, E.Manager_ID;