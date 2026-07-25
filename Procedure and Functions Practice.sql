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
BEGIN 
IF Input1 > Input2 THEN 
SELECT Input1 AS "Bigger Number";
ELSEIF Input2 > Input1 THEN
SELECT Input2 AS "Bigger Number";
ELSE
SELECT 'Big Number' AS 'Equal';
END IF;
END$$
DELIMITER ;

CALL FindBigNum_2(10.0,10.0);

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
DECLARE Number1 INT;
SET Number1 = A;
SET A=B;
SET B=Number1;
END$$
DELIMITER ;

SET @A = 5;
SET @B =10;
CALL SWAPNUM (@A,@B);
SELECT @A AS 'A', @B AS 'B';

-- Procedure to Celsius -- 
DELIMITER $$
CREATE PROCEDURE CelsToFahr (INOUT A FLOAT)
BEGIN
DECLARE Fahrenheit FLOAT;
SET Fahrenheit = (A * 1.8) + 32;
SET A = Fahrenheit;
END$$
DELIMITER ;

SET @A =32;
CALL CelstoFahr (@A);
SELECT @A AS Fahrenheit;

DELIMITER $$
CREATE PROCEDURE PRINT (IN A FLOAT)
BEGIN
SELECT A AS OUTPUT;
END$$
DELIMITER ;

CALL PRINT (@A);

-- Find if number is even or odd --
DELIMITER $$
CREATE PROCEDURE EVENORODD (IN A INT)
BEGIN
IF A%2 = 0 THEN                -- % is for remainder and / is for quoteint --
SELECT "EVEN" AS RESULT;
ELSE 
SELECT "ODD" AS RESULT;
END IF;
END$$
DELIMITER ;

CALL EVENORODD (33);

DELIMITER $$
CREATE PROCEDURE PosNegZero (IN A INT)
BEGIN
IF A > 0 THEN               
SELECT "POSITIVE" AS RESULT;
ELSEIF
A < 0 THEN               
SELECT "NEGATIVE" AS RESULT;
ELSE
SELECT "ZERO" AS RESULT;
END IF;
END$$
DELIMITER ;

CALL PosNegZero (24);
CALL PosNegZero (-24);
CALL PosNegZero (0);

-- Leap Year Checker --
DELIMITER $$
CREATE PROCEDURE LeapYear (IN A INT)
BEGIN
IF (A%4=0 AND A%100 !=0) OR A%400 =0 THEN
SELECT "LEAP YEAR" AS RESULT;
ELSE 
SELECT "NOT LEAP YEAR" AS RESULT;
END IF;
END$$
DELIMITER ;

CALL LeapYear (2025);

