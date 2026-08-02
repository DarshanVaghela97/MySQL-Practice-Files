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

CALL Total_Payment(3);

-- (3) Write a stored procedure to insert a new city into the city table (World DB) --
DESCRIBE CITY;

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




