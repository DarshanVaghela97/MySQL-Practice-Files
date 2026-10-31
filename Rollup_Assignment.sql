CREATE DATABASE ROLLUP_Assignment;
USE ROLLUP_Assignment;

-- Basic Sales Summary --
CREATE TABLE IF NOT EXISTS BASIC_SALES_SUMMARY (
Region VARCHAR(10),
Product VARCHAR(10),
Sales INT
);

INSERT INTO BASIC_SALES_SUMMARY 
VALUES 
('North','Pen',200),
('North','Pencil',150),
('South','Pen',180),
('South','Pencil',200);

SELECT * FROM BASIC_SALES_SUMMARY;

SELECT 
COALESCE (Region, 'All Regions') AS Region,
COALESCE (Product, 'All Products') AS Product,
sum(Sales) AS Total_Sales
FROM BASIC_SALES_SUMMARY
GROUP BY Region,Product WITH ROLLUP;


-- Monthly Sales with Yearly Totals --

CREATE TABLE IF NOT EXISTS MONTHLY_SALES (
`YEAR` INT,
`MONTH` CHAR(3),
REVENUE INT
);

INSERT INTO MONTHLY_SALES 
VALUES 
(2023,'Jan',10000),
(2023,'Feb',12000),
(2024,'Jan',15000),
(2024,'Feb',18000);

SELECT * FROM MONTHLY_SALES;

SELECT 
COALESCE (`MONTH`, 'Total Revenue') AS `Month`,
COALESCE (`Year`, 'All Years') AS `Year`,
sum(Revenue) AS Total_Revenue
FROM MONTHLY_SALES
GROUP BY `Year`,`Month` WITH ROLLUP;


-- Customer Order Summary --

CREATE TABLE IF NOT EXISTS Orders (
Customer VARCHAR(10),
Product VARCHAR(10),
Quantity INT
);

INSERT INTO Orders VALUES 
('Alice','Laptop',2),
('Alice','Mouse',5),
('Bob','Laptop',1),
('Bob','Keyboard',3);

SELECT * FROM Orders;

SELECT 
COALESCE (Customer, 'Total') AS Customer,
COALESCE (Product, 'All Product') AS Product,
sum(Quantity) AS Quantity
FROM Orders
GROUP BY Customer,Product WITH ROLLUP;

-- Store Order Summery --

CREATE TABLE IF NOT EXISTS StoreSales (
Store VARCHAR(10),
Category VARCHAR(20),
`Month` CHAR(3),
Sales INT
);

INSERT INTO StoreSales VALUES 
('StoreA','Electronics','Jan',5000),
('StoreA','Furniture','Jan',3000),
('StoreB','Electronics','Jan',7000),
('StoreB','Furniture','Feb',2000);

SELECT * FROM StoreSales;

SELECT 
COALESCE (Store, 'All Stores') AS Store,
COALESCE (Category, 'All Categories') AS Category,
COALESCE (`MONTH`, 'Total Sales') AS `Month`,
sum(Sales) AS Sales
FROM StoreSales
GROUP BY Store,Category,`Month` WITH ROLLUP;