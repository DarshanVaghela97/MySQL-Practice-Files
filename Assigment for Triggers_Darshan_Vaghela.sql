										-- SAKILA DATABASE --

-- 1. Create a trigger that automatically sets the last_update column in the film table before any update. --

DELIMITER //
CREATE TRIGGER LAST_UPDATE_FILM
BEFORE UPDATE ON FILM FOR EACH ROW
BEGIN
	SET NEW.last_update = NOW();
	END //
DELIMITER ;

UPDATE film
SET length=87 WHERE FILM_ID = 1;                         -- Changed length to check if trigger is working or not --

SELECT * FROM film;

-- 2. Write a trigger to log every new rental into a separate table rental_log after an INSERT on rental. --
SELECT * FROM rental;

CREATE TABLE IF NOT EXISTS rental_log (
log_id INT AUTO_INCREMENT PRIMARY KEY,
rental_id INT,
customer_ID INT,
Rental_Date DATETIME,
Log_Time DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER INSERT_LOG_RENTAL
AFTER INSERT ON rental FOR EACH ROW
BEGIN
	INSERT INTO rental_log (rental_id, customer_id,rental_date) 
    VALUES (NEW.rental_id, NEW.customer_id, NEW.rental_date);
	END //
DELIMITER ;

INSERT INTO rental (rental_date, inventory_id,customer_id,staff_id)
VALUES (NOW(),367,130,1);
SELECT * FROM Payment;
SELECT * FROM rental;
SELECT * FROM rental_log;

-- 3. Create a trigger that prevents deleting a customer if they still have rentals. --
DELIMITER //
CREATE TRIGGER Prevent_customer_delete
BEFORE DELETE ON customer
FOR EACH ROW
BEGIN
    DECLARE rental_count INT;
    SELECT COUNT(*) INTO rental_count FROM rental WHERE customer_id = OLD.customer_id;
    IF rental_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete customer: existing rentals found';
    END IF;
END //
DELIMITER ;

SELECT customer_id, COUNT(*) FROM rental WHERE Customer_id = 148;
-- Customer ID 148 Has 46 Rental. So Trigger will stop from deleting in Customer_table --

DELETE FROM customer WHERE customer_id = 148;

-- 4. Write a trigger that logs whenever a payment is inserted (store customer_id, amount, payment_date into payment_audit). --
SELECT * FROM Payment;

CREATE TABLE IF NOT EXISTS payment_audit (
customer_id INT,
amount DECIMAL(5,2),
payment_date DATETIME,
log_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER payment_log
AFTER INSERT ON payment FOR EACH ROW
BEGIN
	INSERT INTO payment_audit (customer_id,amount,payment_date)
    VALUES (NEW.customer_id,NEW.amount,NEW.payment_date);
    END //
DELIMITER ;

INSERT INTO payment (customer_id,staff_id,rental_id,amount,payment_date,last_update)
VALUES (130,1,16050,0.99,NOW(),NOW());

SELECT * FROM Payment;
SELECT * FROM payment_audit;

-- 5. Create a trigger to prevent negative payment amounts from being inserted. --
DELIMITER //
CREATE TRIGGER Prevent_negative_payment
BEFORE INSERT ON payment
FOR EACH ROW
BEGIN
    IF NEW.amount < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Payment amount cannot be negative';
    END IF;
END //
DELIMITER ;

SELECT * FROM Payment WHERE Customer_id = 148;

-- This will give error message --
INSERT INTO payment (customer_id, staff_id, rental_id, amount, payment_date, last_update)
VALUES (148, 1, 1, -5.00, NOW(), NOW());

-- 6. Write a trigger that updates the last_update column in inventory whenever a film is updated. --
SELECT * FROM inventory;
SELECT * FROM Film;

DELIMITER //
CREATE TRIGGER INVENTORY_UPDATE
AFTER UPDATE ON film FOR EACH ROW
BEGIN
	UPDATE inventory
    SET last_update = NOW()
    WHERE film_id = NEW.film_id;
END //
DELIMITER ;

UPDATE film
SET length=88 WHERE FILM_ID = 1;    

-- 7. Create a trigger to automatically capitalize film titles before insert. --
DELIMITER //
CREATE TRIGGER CAPITAL_TITLES
BEFORE INSERT ON Film FOR EACH ROW
BEGIN
	SET NEW.title = UPPER(NEW.title);
END //
DELIMITER ;

INSERT INTO FILM 
(title,description,release_year,language_id,rental_duration,rental_rate,length,replacement_cost,rating,special_features,last_update)
VALUES
('the odyssey','A historic action-adventure movie by Christopher Nolan',2026,1,7,4.99,172,24.99,'R','Trailers,Behind the scenes',NOW());

SELECT * FROM FILM;

-- 8. Write a trigger that logs when a customer’s email is updated into a table customer_email_history. --
CREATE TABLE IF NOT EXISTS Email_id_Log (
Log_Id INT AUTO_INCREMENT PRIMARY KEY,
Customer_id INT,
First_Name VARCHAR (45),
Last_Name VARCHAR (45),
Old_Email_Id VARCHAR(50),
Email_update_Date DATETIME
);

DELIMITER //
CREATE TRIGGER Before_Email_Update
BEFORE UPDATE ON customer FOR EACH ROW
BEGIN
	INSERT INTO Email_id_Log (Customer_ID,First_Name,Last_Name,Old_Email_Id,Email_update_Date) 
    VALUES (OLD.Customer_ID,OLD.First_Name,OLD.Last_Name,OLD.email,NOW()
    );
END //
DELIMITER ;

UPDATE customer
SET email = 'TIRTHMODI.01@GMAIL.COM' WHERE customer_id = 1;

SELECT * FROM customer;
SELECT * FROM Email_id_Log;

-- 9.Create a trigger that prevents deleting staff members with active = 1. --
DELIMITER //
CREATE TRIGGER Prevent_staff_delete
BEFORE DELETE ON staff
FOR EACH ROW
BEGIN
    IF OLD.active = 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete an active staff member';
    END IF;
END //
DELIMITER ;

SELECT * FROM staff WHERE active = 1;   -- Staff ID 1 and 2 both are active --

DELETE FROM staff WHERE staff_id = 1;


-- 10. Write a trigger that stores deleted film records into a table film_archive before they are deleted. --
SELECT * FROM Film;

CREATE TABLE DELETED_FILMS (
LOG_ID INT AUTO_INCREMENT,
Film_id INT,
title VARCHAR(128),
`Description` TEXT,
Release_year YEAR,
language_id INT,
original_language_id INT,
rental_duration INT,
rental_rate DECIMAL (5,2),
length INT,
replacement_cost DECIMAL (5,2),
rating VARCHAR(10),
special_features VARCHAR(128),
last_update TIMESTAMP,
DELETED_ON TIMESTAMP,
Primary key (LOG_ID)
);

DELIMITER //
CREATE TRIGGER Film_Delete_log
BEFORE DELETE ON film FOR EACH ROW
BEGIN
	INSERT INTO DELETED_FILMS (
    film_id,
    title,
    `description`,
    release_year,
    language_id,
    original_language_id,
    rental_duration,
    rental_rate,
    `length`,
    replacement_cost,
    rating,
    special_features,
    last_update,
    DELETED_ON
    )
VALUES (
	OLD.film_id,
    OLD.title,
    OLD.`description`,
    OLD.release_year,
	OLD.language_id,
    OLD.original_language_id,
    OLD.rental_duration,
    OLD.rental_rate,
    OLD.`length`,
    OLD.replacement_cost,
    OLD.rating,
    OLD.special_features,
    OLD.last_update,
    NOW()
    );
END //
DELIMITER ;

DELETE FROM Film
WHERE film_id =1001;                    -- DELETED THE FILM WHICH I INSERTED FOR QUESTION 7 --

SELECT * FROM film;
SELECT * FROM DELETED_FILMS;


										-- WORLD DATABASE --

-- 11. Create a trigger that prevents inserting a country with a population less than 1000. --
SELECT * FROM Country;

DELIMITER //
CREATE TRIGGER Prevent_Country_Insert
BEFORE INSERT ON Country FOR EACH ROW
BEGIN
	IF NEW.Population < 1000 THEN
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot insert population less than 1000';
	END IF;
END //
DELIMITER ;

INSERT INTO Country (`Name`,Population) 
VALUES ('Vatican City',700);

-- 12. Write a trigger to automatically update a column last_modified in city after update. --
SELECT * FROM City;

CREATE TABLE IF NOT EXISTS CITY_UPDATE_LOG (
UpdateLogID INT AUTO_INCREMENT PRIMARY KEY,
City_ID INT,
Last_Modified TIMESTAMP
);

DELIMITER //
CREATE TRIGGER LAST_MODIFIED_CITY
BEFORE UPDATE ON City FOR EACH ROW
BEGIN
	INSERT INTO CITY_UPDATE_LOG 
    (City_ID,Last_Modified) VALUES
	(NEW.ID, NOW());
	END //
DELIMITER ;

-- Changed Population of Kabul from 1780000 to 1780001 --
UPDATE City
SET Population = 1780001 WHERE Name = 'Kabul';

SELECT * FROM CITY_UPDATE_LOG;

-- 13. Create a trigger that logs all newly inserted countries into a table country_audit. --
SELECT * FROM Country;

CREATE TABLE IF NOT EXISTS country_audit (
	Log_id INT AUTO_INCREMENT PRIMARY KEY,
    code CHAR(3),
    name VARCHAR(52),
    Inserted_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER Country_audit_Trigger
AFTER INSERT ON country
FOR EACH ROW
BEGIN
    INSERT INTO country_audit (code, name)
    VALUES (NEW.Code, NEW.Name);
END //
DELIMITER ;

INSERT INTO country (Code, Name, Continent, Population)
VALUES ('XYZ', 'XYZCountry', 'Asia', 5000);

SELECT * FROM Country;
SELECT * FROM country_audit;

-- 14. Write a trigger that prevents updating the continent of a country once it is set. --
SELECT * FROM Country;

DELIMITER //
CREATE TRIGGER Prevent_Continent_Update
BEFORE UPDATE ON country
FOR EACH ROW
BEGIN
	IF NEW.Continent != OLD.Continent THEN
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot update Continent';
	END IF;
END //
DELIMITER ;

UPDATE COUNTRY
SET continent = 'Asia' WHERE `Name` = 'United States';

-- 15. Create a trigger that logs when a country’s life expectancy is updated into life_audit.--
CREATE TABLE IF NOT EXISTS Life_exp_audit (
LOG_ID INT AUTO_INCREMENT PRIMARY KEY,
Code CHAR(3),
Name VARCHAR(52),
Old_LifeExpectancy DECIMAL(3,1),
NEW_LifeExpectancy DECIMAL(3,1),
updated_on TIMESTAMP
);

DELIMITER //
CREATE TRIGGER Life_EXP_UPDATE
AFTER UPDATE ON country
FOR EACH ROW 
BEGIN
	IF OLD.LifeExpectancy != NEW.LifeExpectancy 
       OR (OLD.LifeExpectancy IS NULL AND NEW.LifeExpectancy IS NOT NULL)
       OR (OLD.LifeExpectancy IS NOT NULL AND NEW.LifeExpectancy IS NULL) THEN
	INSERT INTO Life_exp_audit (`code`,`name`,Old_LifeExpectancy,NEW_LifeExpectancy,updated_on) 
    VALUES (NEW.`code`,NEW.`name`,OLD.LifeExpectancy,NEW.LifeExpectancy,NOW());
    END IF;
END //
DELIMITER ;

SELECT * FROM Country;

-- Update LifeExpectancy of Aruba from 78.4 to 78.5 --
UPDATE country
SET LifeExpectancy = 78.5 WHERE CODE = 'ABW';

SELECT * FROM Country;
SELECT * FROM Life_exp_audit;

-- 16. Create a trigger that prevents deleting a country if it has cities in the city table. --
SELECT * FROM country;
SELECT * FROM city;

DELIMITER //
CREATE TRIGGER PREVENT_COUNTRY_DELETE
BEFORE DELETE ON country
FOR EACH ROW 
BEGIN
	DECLARE city_count INT;
    SELECT count(*) INTO city_count FROM city WHERE CountryCode = OLD.code;
	IF city_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete country: cities exist for this country';
    END IF;
END //
DELIMITER ;

DELETE FROM Country 
WHERE `Name` = 'Afghanistan';

-- 17. Write a trigger that automatically sets the district of a new city to 'Unknown' if it is not provided. --
SELECT * FROM CITY;

DELIMITER //
CREATE TRIGGER Unknown_District
BEFORE INSERT ON City
FOR EACH ROW 
BEGIN
	IF NEW.District IS NULL 
    OR NEW.District = ''
    THEN
	Set NEW.District = 'Unknown';
    END IF;
END //

INSERT INTO CITY (Name,CountryCode,Population)
VALUES ('CITYEXAMPLE','IND',2000);

SELECT * FROM CITY WHERE `Name` ='CITYEXAMPLE';

-- 18. Create a trigger that logs all deleted cities into a city_archive table. --
CREATE TABLE IF NOT EXISTS city_archive (
    LOG_id INT AUTO_INCREMENT PRIMARY KEY,
    city_id INT,
    name CHAR(35),
    countrycode CHAR(3),
    deleted_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER LOG_DELETED_CITY
BEFORE DELETE ON city
FOR EACH ROW
BEGIN
    INSERT INTO city_archive (city_id, name, countrycode)
    VALUES (OLD.ID, OLD.Name, OLD.CountryCode);
END //
DELIMITER ;

DELETE FROM city
WHERE `Name` ='CITYEXAMPLE';

SELECT * FROM city_archive;

-- 19. Write a trigger that prevents inserting a countrylanguage if the language already exists for that country. --
SELECT * FROM countrylanguage;

DELIMITER //
CREATE TRIGGER Prevent_duplicate_language
BEFORE INSERT ON countrylanguage
FOR EACH ROW
BEGIN
    DECLARE lang_count INT;
    SELECT COUNT(*) INTO lang_count
    FROM countrylanguage
    WHERE CountryCode = NEW.CountryCode AND Language = NEW.Language;
    IF lang_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'This language already exists for this country';
    END IF;
END //
DELIMITER ;

SELECT * FROM countrylanguage WHERE CountryCode = 'IND';

-- Hindi Language already exists in table so trigger will give Error --
INSERT INTO countrylanguage (CountryCode, Language, IsOfficial, Percentage)
VALUES ('IND', 'Hindi', 'T', 40.0);

-- 20. Create a trigger that updates a column update_time in countrylanguage whenever a language record is modified.--
SELECT * FROM countrylanguage;

CREATE TABLE IF NOT EXISTS countrylanguage_update_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    CountryCode CHAR(3),
    Language CHAR(30),
    updated_on DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER Countrylanguage_update_time
BEFORE UPDATE ON countrylanguage
FOR EACH ROW
BEGIN
    INSERT INTO countrylanguage_update_log (CountryCode, Language)
    VALUES (NEW.CountryCode, NEW.Language);
END //
DELIMITER ;

-- Update Percentage for ABW Dutch from 5.3 to 5.4 --
UPDATE countrylanguage
SET Percentage = 5.4 
WHERE CountryCode = 'ABW' AND Language = 'Dutch';

SELECT * FROM CountryLanguage;
SELECT * FROM countrylanguage_update_log;