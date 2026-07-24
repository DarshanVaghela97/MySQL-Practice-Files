CREATE DATABASE `Darshan Practice`;
USE `Darshan Practice`;

-- Create procedure that takes number and returns cube --
DELIMITER $$
CREATE PROCEDURE FindCube (IN Input INT, OUT Output INT)
BEGIN 
SET Output = Input * Input * Input;
END$$
DELIMITER ;

CALL FindCube (5,@Output);
SELECT @Output AS 'Cube';

-- Find Largest number from two numbers --
DELIMITER $$
CREATE PROCEDURE FindBigNum (IN Input1 Decimal (10,2),IN Input2 Decimal (10,2))
BEGIN
DECLARE RESULT Decimal (10,2);
IF Input1 > Input2 THEN 
SET RESULT = Input1;
ELSE 
SET RESULT = Input2;
END IF;
SELECT RESULT AS "Bigger Number";
END$$
DELIMITER ;

CALL FindBigNum(10.5,10.7);

-- Now Same Procedure as above but what if both numbers are same --
DELIMITER $$
CREATE PROCEDURE FindBigNum_2 (IN Input1 Decimal (10,2),IN Input2 Decimal (10,2))
-- STOP --

-- Find Area of Circle --
DELIMITER $$
CREATE PROCEDURE CircleArea (IN Radius FLOAT)
BEGIN
DECLARE AREA FLOAT;
SET AREA = 3.14 * Pow(Radius,2);
SELECT AREA AS 'Area of Circle';
END$$
DELIMITER ;

CALL CircleArea(3);
CALL CircleArea(7);

-- Swap Two Numbers using INOUT --
DELIMITER $$
CREATE PROCEDURE SwapNum (INOUT A INT, INOUT B INT)
BEGIN 


