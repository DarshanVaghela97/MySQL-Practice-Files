Create database customer;
USE Customer;

CREATE TABLE IF NOT EXISTS customer_X(
Customer_Id int NOT NULL,
Name varchar(20) NOT NULL,
Age int NOT NULL,
Address varchar(25) ,
Salary decimal (18, 2),
PRIMARY KEY (Customer_ID)
);

CREATE TABLE if not exists Orders(
OrderID int NOT NULL PRIMARY KEY,
OrderNumber int NOT NULL,
Customer_ID int,
CONSTRAINT FK_customerOrder FOREIGN KEY (Customer_ID)
REFERENCES customer_X (Customer_ID)
);

CREATE TABLE if not exists Sales(
SalesID int NOT NULL PRIMARY KEY,
SalesNumber int NOT NULL,
OrderId int,
CONSTRAINT FK_OrderSales FOREIGN KEY(OrderID)
REFERENCES orders (OrderID)
);

SELECT * FROM CUSTOMER_X;
SELECT * FROM Orders;

desc orders;
DESCRIBE ORDERS;

desc sales;

desc CUSTOMER_X;
DESCRIBE CUSTOMER_X;

ALTER TABLE sales
ADD constraint FOREIGN KEY (OrderID) REFERENCES orders(OrderID);

ALTER TABLE sales
DROP FOREIGN KEY FK_OrderSales;

