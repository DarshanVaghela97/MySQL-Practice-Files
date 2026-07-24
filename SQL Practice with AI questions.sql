USE SAKILA;
SHOW TABLES;
SELECT * FROM CUSTOMER;
SELECT first_name,last_name from CUSTOMER;
SELECT * FROM FILM;
SELECT title FROM FILM;
SELECT DISTINCT(RATING) FROM FILM;
SELECT first_name from CUSTOMER WHERE first_name="MARY";
SELECT film_id,title,rating,rental_duration FROM film WHERE rental_duration=7;
SELECT * FROM film WHERE replacement_cost>20;
SELECT * FROM customer WHERE store_id=1;
SELECT film_id,title,rating,release_year FROM film WHERE release_year=2006;
SELECT * FROM film ORDER BY title;
SELECT first_name,last_name FROM customer ORDER BY last_name DESC;
SELECT * FROM film ORDER BY rental_rate DESC;
SELECT * FROM payment;
SELECT * FROM payment ORDER BY amount DESC;
SELECT * FROM FILM LIMIT=10;
SELECT * FROM FILM LIMIT 10;
SELECT * FROM Film ORDER BY replacement_cost Limit 5;
SELECT * FROM Film ORDER BY replacement_cost DESC Limit 5;
SELECT * FROM payment Order by amount DESC limit 20;
SELECT max(amount) FROM payment;
SELECT min(amount) FROM payment;
SELECT avg(amount) FROM payment;
SELECT min(replacement_cost) from Film;
SELECT title,rental_rate,rating From film where rental_rate=0.99 AND rating="PG";
SELECT title,rental_rate,rating From film where rating="PG" OR rating="G";
SELECT first_name,last_name,store_id,active FROM Customer WHERE store_id=1 AND Active=1;
SELECT * FROM film WHERE length>120 AND replacement_cost>20;
SELECT * FROM Payment WHERE amount=0.99 OR amount=4.99;
SELECT First_name,Last_name FROM Customer WHERE first_name LIKE "A%";
SELECT First_name,Last_name FROM Customer WHERE last_name LIKE "%SON";
SELECT First_name,Last_name FROM Customer WHERE first_name LIKE "%AN%";
SELECT title FROM film WHERE title LIKE "C%";
SELECT title FROM film WHERE title LIKE "%LOVE%";
SELECT title FROM film WHERE title LIKE "C%";
SELECT * FROM film_actor;
SELECT * FROM actor WHERE last_name LIKE "M%";
-- MIX PRACTICE(COMBINE EVERYTHING) --
SELECT title,length,rating FROM FILM ORDER BY length DESC Limit 10;
SELECT avg(amount) FROM payment WHERE amount>4;
SELECT title,rating,Length FROM film WHERE rating="PG-13" ORDER BY LENGTH DESC;
SELECT First_name,last_name,store_id FROM CUSTOMER WHERE first_name LIKE "J%" AND store_id=1;
SELECT * FROM film WHERE replacement_cost = (SELECT MAX(replacement_cost)FROM film);
SELECT * FROM film WHERE Length = (SELECT min(length) FROM film);
SELECT * FROM film WHERE title Like "A%" limit 15;
SELECT * FROM film WHERE title Like "%AIR%" OR title Like "%LOVE%";
SELECT * FROM film order by length limit 10;
SELECT film_id,title,length,rental_rate FROM film WHERE rental_rate BETWEEN 2 AND 4;
SELECT first_name,Last_name FROM customer WHERE first_name LIKE "M%" OR last_name LIKE "S%";
SELECT avg(replacement_cost) from FILM;
SELECT title,length FROM film WHERE length = (SELECT max(length) FROM Film);
SELECT title,length FROM film WHERE length > (SELECT avg(length) FROM Film);
SELECT first_name FROM customer WHERE first_name like "_____";
SELECT distinct(amount) FROM payment ORDER BY amount DESC limit 3;
SELECT title,rating FROM film ORDER BY rating,title;
-- Assignment--
SELECT Rating,Count(*) AS Number_of_Films from FIlm group by rating;
SELECT film_id,title,rental_rate FROM film WHERE rental_rate>(SELECT avg(rental_rate) FROM film);
SELECT avg(rental_rate)FROM Film;
SELECT * FROM film;
SELECT * FROM rental;
SELECT distinct(inventory_id) from rental;
SELECT * FROM payment;
SELECT count(inventory_id) from rental;
SELECT count(inventory_id) from rental;
SELECT inventory_id,count(inventory_id) AS TIMES_RENTED from rental GROUP BY inventory_id ORDER BY TIMES_RENTED DESC;

SELECT inventory_id, COUNT(*) AS rental_count
FROM rental
GROUP BY inventory_id
HAVING COUNT(*) = (
    SELECT MAX(rental_count)
    FROM (
        SELECT COUNT(*) AS rental_count
        FROM rental
        GROUP BY inventory_id
    ) AS t
);

SELECT * FROM PAYMENT;
SELECT customer_id,sum(amount) FROM payment GROUP BY customer_ID ORDER BY sum(amount) DESC LIMIT 5;
Select * FROM payment where amount=(SELECT max(amount) FROM payment);
SELECT max(amount) FROM payment;
SELECT count(*) FROM payment GROUP BY CUSTOMER_ID;
SELECT customer_id, count(amount) AS Total_Payment FROM payment GROUP BY customer_id HAVING count(amount)>40;

SELECT * FROM rental;
SELECT * FROM Film;
SELECT * FROM STAFF;
SELECT COUNT(*) AS Total_Staff_Members FROM STAFF;
SELECT rental_id, amount FROM payment ORDER BY amount DESC LIMIT 10;
SELECT * FROM rental ORDER BY rental_date DESC;
SELECT Active,count(*) AS No_of_Customers FROM CUSTOMER GROUP BY Active;
SELECT Rating,avg(rental_duration) AS AVG_RENTAL_DURATION FROM Film GROUP BY Rating;
SELECT * FROM payment;

SELECT
    Customer.customer_id,
    Customer.first_name,
    Customer.last_name,
    SUM(Payment.amount) AS Total_Payment
FROM Payment
JOIN Customer
ON Payment.customer_id = Customer.customer_id
GROUP BY
    Customer.customer_id,
    Customer.first_name,
    Customer.last_name;

USE WORLD;
SELECT Name,(GNP/Capital) AS GNP_Per_Capita FROM Country WHERE (GNP/Capital)=(SELECT AVG(GNP/Capital) FROM COUNTRY);

SELECT Name, (GNP / Capital) AS GNP_Per_Capita
FROM Country
WHERE (GNP / Capital) > (
    SELECT AVG(GNP / Capital)
    FROM Country
);

SELECT Name,(GNP/Capital) AS GNP_Per_Capita FROM Country HAVING GNP_Per_Capita>(SELECT AVG(GNP/Capital) FROM COUNTRY);

SELECT Continent,sum(population) FROM Country Group by Continent;

SELECT * FROM country WHERE GovernmentForm Like '%Monarchy%';

SELECT * FROM countrylanguage;
SELECT * FROM country;
SELECT C.code,C.Name,CL.Language FROM country AS C JOIN countrylanguage AS CL ON C.CODE=CL.CountryCode WHERE CL.Language = 'English';