CREATE DATABASE MERGE_Statement;
USE MERGE_Statement;

CREATE TABLE Inventory (
	Product_ID INT Primary Key,
    Quantity INT 
);

CREATE TABLE Inventory_Updates (
	Product_ID INT Primary Key,
    Quantity INT
);

INSERT INTO Inventory (Product_ID, Quantity) VALUES
(1, 10),
(2, 20);

INSERT INTO Inventory_Updates (Product_ID, Quantity) VALUES
(2,25),
(3,15);

INSERT INTO Inventory_Updates (Product_ID, Quantity) VALUES
(1, 25),
(2, 35),
(5, 10)
ON DUPLICATE KEY UPDATE
Quantity = VALUES(Quantity);

SELECT * FROM Inventory;
SELECT * FROM Inventory_Updates;

MERGE INTO Inventory AS target
USING Inventory_Updates AS source
ON target.Product_ID = source.Product_ID
WHEN MATCHED THEN
	UPDATE SET QUANTITY = source.Quantity
WHEN NOT MATCHED THEN
	INSERT (Product_ID, Quantity) VALUES (source.Product_ID, source.Quantity);

-- MySQL does not support the MERGE statement. --
-- Query is valid syntax in databases such as SQL Server, Oracle, PostgreSQL (with newer features/variants), but MySQL has no MERGE INTO. --

##---- OR ----##

INSERT INTO Inventory (Product_ID, Quantity)
SELECT Product_ID, Quantity FROM Inventory_Updates
ON DUPLICATE KEY UPDATE
	Quantity = VALUES(Quantity);
    
##---- OR ----##

INSERT INTO Inventory (Product_ID, Quantity)
SELECT Product_ID, Quantity FROM Inventory_Updates AS new
ON DUPLICATE KEY UPDATE
	Quantity = VALUES(Quantity);
    
SELECT * FROM Inventory;
