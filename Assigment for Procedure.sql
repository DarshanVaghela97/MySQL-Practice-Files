-- (1)Write a Stored Procedure to display all films from the Film Table (Sakila)--
DELIMITER $$
CREATE PROCEDURE ALL_FILMS ()
BEGIN
SELECT * FROM FILM;
END$$
DELIMITER ;

CALL ALL_FILMS;

-- (2)Create a stored procedure that accepts a customer_id and returns their total payments --
DELIMITER $$
CREATE PROCEDURE Total_Payment (IN ID INT)
BEGIN
SELECT sum(amount) AS 'TOTAL PAYMENT' FROM PAYMENT WHERE CUSTOMER_ID = ID;
END$$
DELIMITER ;

CALL Total_Payment(5);

-- (3) Write a stored procedure to insert a new city into the city table (World DB) --
DELIMITER $$
CREATE PROCEDURE InCityCodeDist (IN City_Name VARCHAR(40),IN CODE CHAR(3),IN District CHAR(20))
BEGIN
Insert into City (Name,CountryCode,District) VALUES (City_Name,Code,District);
END$$
DELIMITER ;

CALL InCityCodeDist ('Anand','IND','Anand');
CALL InCityCodeDist ('Vadodara','IND','Vadodara');

SELECT * FROM CITY WHERE Name = 'Vadodara' OR Name = 'Anand';

-- (4) Create a procedure that shows the top 5 most rented films (Sakila) --
DELIMITER $$
CREATE PROCEDURE Top5Rented()
BEGIN
SELECT f.film_id,f.title,count(r.rental_id) AS Times_Rented FROM Film AS f 
JOIN Inventory AS i ON f.film_id = i.film_id 
JOIN Rental AS r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title 
ORDER BY Times_Rented DESC
LIMIT 5;
END$$
DELIMITER ;

CALL Top5Rented ();

-- (5) Write a procedure that returns the total number of countries per continent (World) --
DELIMITER $$
CREATE PROCEDURE CountryPerContinent ()
BEGIN
SELECT Continent,count(name) AS 'Number of Countries' FROM COUNTRY GROUP BY Continent;
END$$
DELIMITER ;

CALL CountryPerContinent ();

-- (6) Create a procedure that accepts a rating (G, PG, R) and returns all films with that rating (Sakila) --
DELIMITER $$
CREATE PROCEDURE FilmByRating (IN FilmRating VARCHAR(20))
BEGIN
SELECT Title,Rating FROM FILM WHERE Rating = FilmRating;
END$$
DELIMITER ;

SET @FilmRating = "R";
CALL FilmByRating (@FilmRating);

-- (7) Write a procedure with IN and OUT parameters: input is country_code, output is population (World) --
DELIMITER $$
CREATE PROCEDURE CodeToPopulation (IN Code CHAR(3),OUT Total_Population INT)
BEGIN
SELECT sum(Population) INTO Total_Population FROM city WHERE countrycode = Code;
END$$
DELIMITER ;

CALL CodeTopopulation ("AFG",@Population);
SELECT @Population AS "Total Population";

-- (8) Create a procedure that accepts a min and max replacement cost and lists films in that range (Sakila) --
DELIMITER $$
CREATE PROCEDURE CostRange (IN MinCost DECIMAL (10,2), IN MaxCost DECIMAL (10,2))
BEGIN
SELECT title,replacement_cost FROM Film WHERE replacement_cost>MinCost AND replacement_cost<MaxCost;
END$$
DELIMITER ;

CALL CostRange (14,20);

-- (9) Write a procedure to find all customers who spent more than X amount, where X is an input parameter --
SELECT C.Customer_id,C.First_Name,C.Last_Name,C.Email,P.Amount,P.Payment_id,P.Payment_date FROM Customer c JOIN Payment AS P ON C.customer_id = P.Customer_id WHERE P.amount>4.00;  

DELIMITER $$
CREATE PROCEDURE CustomerByAmount (IN X DECIMAL (5,2))
BEGIN 
SELECT C.Customer_id,C.First_Name,C.Last_Name,C.Email,P.Amount,P.Payment_id,P.Payment_date FROM Customer c JOIN Payment AS P ON C.customer_id = P.Customer_id WHERE P.amount>X;  
END$$
DELIMITER ;

CALL CustomerByAmount (9.00);
-- SAME QUESTION BUT CHECKING BY TOTAL SPENDING OF CUSTOMER -- 
SELECT C.Customer_id,C.First_Name,C.Last_Name,C.Email,sum(P.Amount) FROM Customer c JOIN Payment AS P ON C.customer_id = P.Customer_id Group BY C.Customer_id HAVING sum(P.amount)>50.00;  

DELIMITER $$
CREATE PROCEDURE CustomerByTotalAmt (IN X DECIMAL (10,2))
BEGIN 
SELECT C.Customer_id,C.First_Name,C.Last_Name,C.Email,sum(P.Amount) FROM Customer c JOIN Payment AS P ON C.customer_id = P.Customer_id Group BY C.Customer_id HAVING sum(P.amount)>X;  
END$$
DELIMITER ;

CALL CustomerByTotalAmt(50.00);

-- (10) Write a procedure that accepts a continent name and returns the average life expectancy of that continent (World) --
DELIMITER $$
CREATE PROCEDURE AvgLifeContinent (IN A VARCHAR(50))
BEGIN 
SELECT avg(LifeExpectancy) AS 'Average Life Expectancy' FROM Country WHERE Continent = A;
END$$
DELIMITER ; 

CALL AvgLifeContinent ('Europe');

-- (11) Write a procedure to categorize films as Short (<60 mins), Medium (60–120 mins), or Long (>120 mins) --
DELIMITER $$
CREATE PROCEDURE FilmLength ()
BEGIN
SELECT Title,Release_Year,Length,
	CASE 
	WHEN length < 60 THEN "Short"
    WHEN length BETWEEN 60 AND 120 THEN "Medium"
    WHEN length >120 THEN "Long" 
END AS 'Film Category'
FROM film;
END $$
DELIMITER ;

CALL FilmLength();


-- (12) Create a procedure that uses a LOOP to print numbers 1–10 -- Stored in World DB --
CREATE TEMPORARY TABLE IF NOT EXISTS PrintNumbers (
NUMBERS INT 
);

DELIMITER $$
CREATE PROCEDURE Numbers_2 (IN Startnum INT, IN EndNum INT)
BEGIN
TRUNCATE TABLE Printnumbers;
Num_Loop : LOOP
	IF StartNum >Endnum THEN
    Leave Num_Loop;
    END IF;
    INSERT INTO PrintNumbers (Numbers) VALUES (Startnum);
    SET StartNum = StartNum + 1;
    END Loop;
SELECT * FROM Printnumbers;
END$$
DELIMITER ;        
        
CALL Numbers_2(1,10);

DELIMITER $$
CREATE PROCEDURE Numbers ()
BEGIN
DECLARE StartNum INT DEFAULT 1;
	While StartNum <=10 DO
    SELECT StartNum AS Numbers;
    SET StartNum = StartNum + 1;
    END WHILE ;
END$$
DELIMITER ;

CALL Numbers();


-- (13) Write a procedure that checks if a given customer_id exists in the customer table and returns "Found" or "Not Found" --
SELECT * FROM CUSTOMER;

DELIMITER $$
CREATE PROCEDURE CheckID (IN ID INT)
BEGIN
DECLARE ID_CHECK INT;
SELECT count(customer_id) INTO ID_CHECK FROM customer WHERE customer_id = ID;
IF ID_CHECK != 0 THEN SELECT "FOUND";
ELSE SELECT "NOT FOUND";
END IF;
END$$
DELIMITER ;

CALL CheckID(700);
SELECT * FROM CUSTOMER;

DELIMITER $$
CREATE PROCEDURE CHECKID_2 (IN ID INT)
BEGIN 
DECLARE Temp_ID INT;
DECLARE ID_Check INT DEFAULT 1;
DECLARE FIND CURSOR FOR SELECT Customer_ID FROM CUSTOMER WHERE Customer_ID = ID;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET ID_CHECK = 0;
OPEN FIND;
FETCH FIND INTO TEMP_ID;
IF ID_CHECK=0 THEN SELECT "NOT FOUND";
ELSE SELECT "FOUND";
END IF ;
CLOSE FIND;
END$$
DELIMITER ;

CALL CheckID_2(700);

-- (14) Create a procedure that updates rental_rate by 10% for all films above 120 minutes --
SELECT title,length,rental_rate FROM FILM WHERE Length >= 120;
DESCRIBE FILM;
SELECT * FROM film;

DELIMITER $$
CREATE PROCEDURE Rental_Rate_10 ()
BEGIN
DECLARE MovieID INT;
DECLARE FilmLength INT;
DECLARE RentalRate Decimal(4,2);
DECLARE RATE_CHECK INT DEFAULT 0;
DECLARE Cursor1 Cursor for SELECT Film_ID,Length,Rental_Rate FROM FILM;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET RATE_CHECK = 1;
OPEN Cursor1;
ADD_10_Rent : LOOP
FETCH Cursor1 INTO MovieID,FilmLength,RentalRate;
IF RATE_CHECK=1 THEN
	LEAVE ADD_10_Rent;
END IF;
IF FilmLength > 120 THEN
	UPDATE Film
	SET Rental_Rate = RentalRate * 1.10
    WHERE Film_ID=MovieID;
END IF;
END LOOP;
CLOSE Cursor1;
END$$
DELIMITER ;

CALL Rental_Rate_10 ();

SELECT title,length,rental_rate FROM FILM WHERE Length >= 120;

-- (15) Write a procedure that finds the first 5 cities alphabetically in the World database using a loop --
SELECT * FROM city ORDER BY NAME LIMIT 5;
DESCRIBE CITy;

DELIMITER $$
CREATE PROCEDURE FiveCity ()


-- (16) Write a procedure using a cursor to display all film titles one by one (Sakila) --
CREATE TEMPORARY TABLE IF NOT EXISTS FilmName (
Film_Title VARCHAR(255)
);

DELIMITER $$
CREATE PROCEDURE FilmTitles()
BEGIN
DECLARE FilmTitle VARCHAR(255);
DECLARE Done INT DEFAULT 0;
DECLARE Cursor1 CURSOR FOR SELECT Title FROM Film;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET Done = 1;
TRUNCATE TABLE FilmName;
OPEN Cursor1;
    TitleLoop: LOOP
	FETCH Cursor1 INTO FilmTitle;
	IF Done = 1 THEN
	LEAVE TitleLoop;
	END IF;
INSERT INTO FilmName VALUES (FilmTitle);
    END LOOP TitleLoop;
CLOSE Cursor1;
SELECT * FROM FilmName;
END$$
DELIMITER ;

CALL FilmTitles ();

-- (17) Create a procedure that uses a cursor to calculate the total population of all countries (World) --
SELECT * FROM Country;

DELIMITER $$
CREATE PROCEDURE TotalPopulation ()
BEGIN
DECLARE PopulationValue INT;
DECLARE TotalPopulation BIGINT DEFAULT 0;
DECLARE DONE INT DEFAULT 0;
DECLARE PopCounter CURSOR FOR SELECT Population FROM Country;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET DONE = 1;
OPEN PopCounter;
	PopulationLoop : LOOP
FETCH PopCounter INTO PopulationValue;
    	IF DONE = 1 THEN 
		Leave PopulationLoop;
        END IF;
    SET TotalPopulation = TotalPopulation + PopulationValue; 
    END LOOP PopulationLoop;
CLOSE PopCounter;
SELECT TotalPopulation AS 'Total Population';
END$$
DELIMITER ;

CALL TotalPopulation();

-- (18) Write a procedure that performs a transaction: deduct amount from one customer’s balance and add it to another --
CREATE TABLE ACCOUNTS (
CUSTOMER_ID INT PRIMARY KEY,
BALANCE DECIMAL(10,2)
);

INSERT INTO ACCOUNTS (CUSTOMER_ID,BALANCE) VALUES 
(1,1000.00),
(2,500.00);

DELIMITER $$
CREATE PROCEDURE TransferBalance (IN From_ID INT, IN To_ID INT, IN TransferAmount DECIMAL(10,2))
BEGIN
DECLARE CurrentBalance DECIMAL(10,2); 
	START TRANSACTION;
        SELECT BALANCE INTO CURRENTBALANCE FROM ACCOUNTS WHERE CUSTOMER_ID = FROM_ID;
	IF CURRENTBALANCE >=TransferAmount THEN
		UPDATE ACCOUNTS SET BALANCE = BALANCE - TransferAmount WHERE CUSTOMER_ID = FROM_ID;
		UPDATE ACCOUNTS SET BALANCE = BALANCE + TransferAmount WHERE CUSTOMER_ID = TO_ID;
        COMMIT;
		ELSE
	ROLLBACK;
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient Balance';
	END IF;
SELECT * FROM ACCOUNTS;
END$$
DELIMITER ; 

CALL TRANSFERBALANCE(1,2,400);

-- (19) Write a procedure that handles an error (e.g., dividing by zero) using DECLARE HANDLER --
DELIMITER $$
CREATE PROCEDURE DIVIDENUMBERS (IN NUM1 DECIMAL(10,2), IN NUM2 DECIMAL(10,2), OUT RESULT DECIMAL(10,2))
BEGIN
DECLARE DIVIDE_BY_ZERO CONDITION FOR SQLSTATE '22012';
DECLARE CONTINUE HANDLER FOR DIVIDE_BY_ZERO
BEGIN 
SET RESULT = NULL;
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Division by Zero is not allowed';
END;
IF NUM2 = 0 THEN
SIGNAL SQLSTATE '22012' SET MESSAGE_TEXT = 'Division by Zero';
ELSE 
SET RESULT = NUM1 / NUM2;
END IF;
END$$
DELIMITER ;

CALL DIVIDENUMBERS(10,0,@RESULT);
SELECT @RESULT;

-- (20) Create a procedure that generates a log entry whenever a new customer is inserted (simulate error logging) -- 

DELIMITER $$
CREATE PROCEDURE InsertCustomer (
IN C_ID INT,
IN C_FirstName VARCHAR(45),
IN C_LastName VARCHAR(45)
)
BEGIN
DECLARE DUPLICATE_ID CONDITION FOR SQLSTATE '45000';
DECLARE CONTINUE HANDLER FOR DUPLICATE_ID
BEGIN
	SELECT C_ID AS Customer_ID,
	'Customer ID already exists' AS Log_Message;
END;
	IF C_ID IN (SELECT Customer_ID FROM Customer) THEN SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT = 'Customer ID already exists';
ELSE
	INSERT INTO Customer (Customer_ID, First_Name, Last_Name)
	VALUES
	(C_ID, C_FirstName, C_LastName);
END IF;
END$$
DELIMITER ;
    