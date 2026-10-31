                                                    -- SAKILA DATABASE --

-- 1.Create a function that takes a film_id and returns its rental_rate. --
DELIMITER $$
CREATE FUNCTION id_to_rental_rate (ID INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC 
BEGIN
	DECLARE Rate DECIMAL(10,2);
    SELECT rental_rate INTO Rate FROM film where film_id = ID;
    Return Rate;
END $$
DELIMITER ;

SELECT id_to_rental_rate (1) AS Rental_Rate;

-- 2. Write a function that accepts a film_id and returns the film title in uppercase. --
DELIMITER $$
CREATE FUNCTION Id_to_Title (ID INT)
RETURNS VARCHAR(128)
DETERMINISTIC 
BEGIN
	DECLARE Film_Title VARCHAR(128);
    SELECT upper(title) INTO Film_Title FROM film where film_id = ID;
    Return Film_Title;
END $$
DELIMITER ;

SELECT Id_to_Title (1) AS Film_Title;

-- 3.Create a function that takes a customer_id and returns the total payments made by that customer. --
DELIMITER $$
CREATE FUNCTION Id_to_Total_Payment (ID INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC 
BEGIN
	DECLARE Total_Payment DECIMAL(10,2);
    SELECT sum(amount) INTO Total_Payment FROM payment where customer_id = ID;
    Return Total_Payment;
END $$
DELIMITER ;

SELECT Id_to_Total_Payment (5) AS Total_Payment;

-- 4.Write a function that returns the number of films available in inventory for a given film_id.-- 
DELIMITER $$
CREATE FUNCTION Count_Films (ID INT)
RETURNS INT
DETERMINISTIC 
BEGIN
	DECLARE Number_of_Films INT;
    SELECT count(inventory_id) INTO Number_of_Films FROM Inventory where Film_id = ID;
    Return Number_of_Films;
END $$
DELIMITER ;

SELECT Count_Films (1) AS 'No. of Films';

-- 5.Create a function that takes a customer_id and returns the total number of rentals. --
DELIMITER $$
CREATE FUNCTION Rental_Count (ID INT)
RETURNS INT
DETERMINISTIC 
BEGIN
	DECLARE Times_Rented INT;
    SELECT count(rental_id) INTO Times_Rented FROM Rental where customer_id = ID;
    Return Times_Rented;
END $$
DELIMITER ;

SELECT Rental_Count (3) AS 'Times Rented';

-- 6. Write a function that accepts a film length and returns whether it is 'Short', 'Medium', or 'Long'. --
DELIMITER $$
CREATE FUNCTION Film_Length (Length INT)
RETURNS VARCHAR(10)
DETERMINISTIC 
BEGIN
	DECLARE category VARCHAR(10);
    IF Length < 70 THEN
        SET category = 'Short';
    ELSEIF Length <= 120 THEN
        SET category = 'Medium';
    ELSE
        SET category = 'Long';
    END IF;
    
    RETURN category;
END $$
DELIMITER ;

SELECT film_id, title, length, Film_Length(length) AS category
FROM film;

-- 7. Create a function that calculates the late fee based on rental days (return difference × rental_rate). --
select * from rental;
select * from inventory;
select * from film;

DELIMITER $$
CREATE FUNCTION Late_Fee (p_rental_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE fee DECIMAL(10,2);

    SELECT DATEDIFF(r.return_date, r.rental_date) * f.rental_rate
    INTO fee
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    WHERE r.rental_id = p_rental_id;

    RETURN fee;
END $$
DELIMITER ;

SELECT Late_Fee(1);

-- 8.Write a function that takes a film title and returns its replacement cost.
SELECT * FROM Film;

DELIMITER $$
CREATE FUNCTION title_to_replacement_cost (Film_Name VARCHAR(128))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE cost DECIMAL(10,2);
    SELECT replacement_cost INTO cost FROM film WHERE title = Film_Name;
    RETURN cost;
END $$
DELIMITER ;

SELECT title_to_replacement_cost ('ACADEMY DINOSAUR')As 'Replacement Cost'; 

-- 9.Create a function that calculates the average rental_rate of all films. --
DELIMITER $$
CREATE FUNCTION Avg_Rental_Rate ()
RETURNS DECIMAL(10,2)
DETERMINISTIC 
BEGIN 
	Declare Avg_Rate DECIMAL(10,2);
    SELECT avg(rental_rate) INTO Avg_Rate FROM film;
    RETURN Avg_Rate;
END $$
DELIMITER ;

SELECT Avg_Rental_Rate();

-- 10.Write a function that accepts a store_id and returns the number of customers registered in that store. --
DELIMITER $$
CREATE FUNCTION Customer_Count_By_Store (ID INT)
RETURNS INT
DETERMINISTIC 
BEGIN
	DECLARE Total_Cust INT;
    SELECT count(customer_id) INTO Total_Cust FROM customer where store_id = ID;
    Return Total_Cust;
END $$
DELIMITER ;

SELECT Customer_Count_By_Store(1);
SELECT Customer_Count_By_Store(2);
SELECT count(customer_id) FROM customer;

													
                                                    -- WORLD DATABASE --

-- 11. Create a function that accepts a country code and returns its population. --
SELECT * FROM Country;

DELIMITER $$
CREATE FUNCTION Population_Count (Country_Code CHAR(3))
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE PopulationNum INT;
    SELECT population INTO PopulationNum FROM Country WHERE `Code` = Country_Code;
    RETURN PopulationNum;
END $$
DELIMITER ;

SELECT Population_Count ('IND') AS 'Country Population';

-- 12. Write a function that accepts a country name and returns its continent --
DELIMITER $$
CREATE FUNCTION Find_Continent (Country VARCHAR(100))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
	DECLARE ContinentName VARCHAR(100);
    SELECT Continent INTO ContinentName FROM Country WHERE `name` = Country;
    RETURN ContinentName;
END $$
DELIMITER ;

SELECT Find_Continent ('INDIA') AS 'Continent';
SELECT Find_Continent ('Australia') AS 'Continent';

--  13. Create a function that calculates the population density (population ÷ surface area) for a given country code. --
DELIMITER $$
CREATE FUNCTION Population_Density (Country_Code CHAR(3))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
	DECLARE Density DECIMAL(10,2);
    SELECT (Population/SurfaceArea) INTO Density FROM Country WHERE `Code` = Country_Code;
    RETURN Density;
END $$
DELIMITER ;

SELECT Population_Density ('IND') AS 'Population Density';
SELECT Population_Density ('AFG') AS 'Population Density';

-- 14. Write a function that returns the life expectancy category (Low, Medium, High) based on value.--
DELIMITER $$
CREATE FUNCTION LifeExpCateogry (LifeExpectancy DECIMAL(10,2))
RETURNS VARCHAR(10)
DETERMINISTIC 
BEGIN
	DECLARE category VARCHAR(10);
    IF LifeExpectancy < 50 THEN
        SET category = 'Low';
    ELSEIF LifeExpectancy <= 120 THEN
        SET category = 'Medium';
    ELSE
        SET category = 'High';
    END IF;
        RETURN category;
END $$
DELIMITER ;

SELECT `name`,Population,LifeExpectancy,LifeExpCateogry(LifeExpectancy) AS 'Life Expectancy Category' FROM Country;

-- 15. Create a function that accepts a city ID and returns the city name. --
DELIMITER $$
CREATE FUNCTION ID_to_City (CityID INT)
RETURNS VARCHAR(50)
DETERMINISTIC 
BEGIN
	DECLARE CityName VARCHAR(10);
    SELECT `name` INTO CityName FROM City where ID = CityID;
    Return CityName;
END $$
DELIMITER ;

SELECT ID_to_City(1);

-- 16. Write a function that accepts a country code and returns the number of cities in that country. --
SELECT * FROM CITY;

DELIMITER $$
CREATE FUNCTION City_Count (`code` CHAR(3))
RETURNS INT 
DETERMINISTIC
BEGIN
	DECLARE CountofCity INT;
    SELECT count(`name`) INTO CountofCity FROM CITY WHERE CountryCode = `code`;
    RETURN CountofCity;
END $$
DELIMITER ;

SELECT City_Count ('IND');
SELECT City_Count ('USA');

-- 17. Create a function that accepts a language and returns how many countries officially speak it. --
SELECT * FROM CountryLanguage;

DELIMITER $$
CREATE FUNCTION Official_Language_Countries (languageName VARCHAR(50))
RETURNS INT 
DETERMINISTIC
BEGIN
	DECLARE CountofCountry INT;
    SELECT count(distinct(CountryCode)) INTO CountofCountry FROM countrylanguage WHERE `Language` = languageName AND IsOfficial = 'T';
    RETURN CountofCountry;
END $$
DELIMITER ;

SELECT Official_Language_Countries ('English') AS 'No. of Countries which officially Speak it';
SELECT Official_Language_Countries ('Hindi') AS 'No. of Countries which officially Speak it';

-- 18. Write a function that calculates the GNP per capita for a given country code. --
DELIMITER $$
CREATE FUNCTION GNP_Per_Capita (Country_Code CHAR(3))
RETURNS Float(10,7)
DETERMINISTIC
BEGIN
	DECLARE GPC float(10,7);
    SELECT (GNP/Population) INTO GPC FROM Country WHERE `Code` = Country_Code;
    RETURN GPC;
END $$
DELIMITER ;

SELECT GNP_Per_Capita ('IND') AS 'GNP PER CAPITA';
SELECT GNP_Per_Capita ('USA') AS 'GNP PER CAPITA';
SELECT GNP_Per_Capita ('AUS') AS 'GNP PER CAPITA';

-- 	19. Create a function that accepts a region name and returns the average population of its countries. -- 
SELECT * FROM COUNTRY;

DELIMITER $$
CREATE FUNCTION Avg_Region_Population (RegionName VARCHAR(30))
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE AvgRegionPopulation INT;
    SELECT AVG(Population) INTO AvgRegionPopulation FROM Country WHERE Region = RegionName;
    RETURN AvgRegionPopulation;
END $$
DELIMITER ;

SELECT Avg_Region_Population('Middle East') AS 'Avg Population of Region';
SELECT Avg_Region_Population('South America')AS 'Avg Population of Region';

-- 20. Create a function that accepts a continent and returns the maximum life expectancy in that continent. --
DELIMITER $$
CREATE FUNCTION Max_LifeEXP_Continent (ContinentName VARCHAR(30))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
	DECLARE MaxLifeEXP INT;
    SELECT MAX(LifeExpectancy) INTO MaxLifeEXP FROM Country WHERE Continent = ContinentName;
    RETURN MaxLifeEXP;
END $$
DELIMITER ;

SELECT Max_LifeEXP_Continent ('Asia') AS 'Max life expectancy in Continent';
SELECT Max_LifeEXP_Continent ('North America') AS 'Max life expectancy in Continent';