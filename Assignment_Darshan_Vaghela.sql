Use Sakila;
-- Find the Top 10 Films with Highest rental_rate--
SELECT Film_id,Title,Rental_rate FROM Film ORDER BY rental_rate DESC LIMIT 10;
-- Show the Film(s) with the Maximum Length--
SELECT Film_id,Title,Length FROM FILM WHERE Length=(SELECT max(length) FROM Film);
-- Count the number of Films in each rating
SELECT Rating,Count(*) AS Number_of_Films from FIlm group by rating;
-- Find the average replacement cost of all films-- 
SELECT avg(replacement_cost) AS Average_Replacement_Cost FROM film;
-- list the 5 most expensive films by replacement cost --
SELECT Film_id,Title,Replacement_cost FROM Film ORDER BY replacement_cost DESC LIMIT 5;
-- Show all films whose rental_rate is higher than the average rental_rate --
SELECT film_id,title,rental_rate FROM film WHERE rental_rate>(SELECT avg(rental_rate) FROM film);
-- Find the minimum rental duration among all films --
SELECT min(rental_duration) AS Minimum_Rental_Duration FROM Film;
-- List all films with a Title starting with 'A' --
SELECT film_id,Title FROM film WHERE title like 'A%';
-- Find the total number of rentals in the rental table --
SELECT count(rental_id) AS TOTAL_RENTALS FROM rental;
-- Show the most frequently rented inventory_id --
SELECT inventory_id,count(rental_id) AS Times_Rented FROM rental GROUP BY inventory_ID ORDER BY Times_Rented DESC;

select * from (SELECT inventory_id,count(rental_id) AS Times_Rented FROM rental GROUP BY inventory_ID ORDER BY Times_Rented DESC) as sub where Times_Rented = 5;

SELECT * FROM (SELECT inventory_id,COUNT(rental_id) AS Times_Rented FROM rental GROUP BY inventory_id) AS sub WHERE Times_Rented = (
SELECT MAX(Times_Rented) FROM (SELECT COUNT(rental_id) AS Times_Rented FROM rental GROUP BY inventory_id) as t
);

with cte as (
SELECT inventory_id,count(rental_id) AS Times_Rented FROM rental GROUP BY inventory_ID ORDER BY Times_Rented DESC
) select inventory_id, Times_Rented from cte where Times_Rented = (
    SELECT MAX(Times_Rented)
    FROM cte);
    
-- Find the top 5 customers by total payment --
SELECT customer_id,sum(amount) FROM payment GROUP BY customer_ID ORDER BY sum(amount) DESC LIMIT 5;
-- Display the maximum payment made in a single transaction --
SELECT max(amount) AS MAXIMUM_PAYMENT FROM payment;
-- Find the average payment amount --
SELECT avg(amount) As AVERAGE_PAYMENT FROM payment;
-- Show the customers who made more than 40 Payments --
SELECT customer_id, count(amount) AS Total_Payment FROM payment GROUP BY customer_id HAVING count(amount)>40;
-- List the films that were rented more than 20 times --
SELECT f.film_id,f.title,count(r.rental_id) AS Times_Rented FROM Film AS f JOIN Inventory AS i ON f.film_id = i.film_id JOIN Rental AS r ON i.inventory_id = r.inventory_id GROUP BY f.film_id, f.title HAVING COUNT(r.rental_id) > 20 ORDER BY Times_Rented DESC;
-- Find the store with the Highest Total Payments Received --
SELECT s.store_id,sum(p.amount) AS total_payment FROM Store AS S JOIN Staff AS SF on S.store_id=SF.store_id JOIN payment AS p on p.staff_id=SF.staff_id GROUP BY s.store_id ORDER BY total_payment DESC Limit 1;
-- Display the total number of staff members --
SELECT COUNT(*) AS Total_Staff_Members FROM STAFF;
-- Show the Top 10 rental transactions by Amount--
SELECT rental_id, amount FROM payment ORDER BY amount DESC LIMIT 10;
-- Find the customer who paid the maximum total amount --
Select customer_id, sum(amount) AS Total_payment FROM payment GROUP BY customer_id ORDER BY Total_payment DESC LIMIT 1;
-- Show the most recent rental date --
SELECT * FROM rental ORDER BY rental_date DESC LIMIT 1;
-- Find the earliest rental date --
SELECT * FROM rental ORDER BY rental_date ASC LIMIT 1;
-- Count the number of customers in each active status (active = 0/1) --
SELECT Active,count(*) AS No_of_Customers FROM CUSTOMER GROUP BY Active;
-- Find all films with a replacement_cost less than 10--
SELECT * FROM Film WHERE replacement_cost<10;
-- Show the average rental duration per rating --
SELECT Rating,avg(rental_duration) AS AVG_RENTAL_DURATION FROM Film GROUP BY Rating;
-- Find the second most rented film using a subquery --
SELECT f.film_id,f.Title,count(rental_id) AS Times_Rented FROM Film AS f JOIN Inventory AS I ON f.film_id=i.film_id JOIN rental AS r ON r.inventory_id=i.inventory_id GROUP BY f.film_id,f.title ORDER BY Times_Rented DESC LIMIT 1,1;

-- WORLD DATABASE --
USE World;
-- Find the 10 most populated countries --
SELECT Name,Population FROM country ORDER BY Population DESC LIMIT 10;
-- Show the country with the smallest surface area --
SELECT Name,SurfaceArea FROM country WHERE SurfaceArea = (SELECT min(SurfaceArea) FROM country);
-- Find the country with the highest life expectancy --
SELECT Name,LifeExpectancy FROM country WHERE LifeExpectancy = (SELECT max(LifeExpectancy) FROM country);
-- Show the top 5 countries by GNP --
SELECT Name,GNP FROM country ORDER BY GNP DESC LIMIT 5;
-- Find all countries where the population is greater than the average population --
SELECT Name,Population FROM Country WHERE Population>(SELECT avg(Population) FROM country);
-- List countries with life expectancy below the world average --
SELECT Name,LifeExpectancy FROM Country WHERE LifeExpectancy<(SELECT avg(LifeExpectancy) FROM COUNTRY);
-- Find all countries where GNP per capita is above the average --
SELECT Name,(GNP/Capital) AS GNP_Per_Capita FROM Country HAVING GNP_Per_Capita>(SELECT AVG(GNP/Capital) FROM COUNTRY);
SELECT Name,(GNP/Capital) AS GNP_Per_Capita FROM Country WHERE (GNP/Capital)>(SELECT AVG(GNP/Capital) FROM COUNTRY);
-- Show the continent with the highest average population --
SELECT Continent,avg(population) AS Average_Population FROM Country GROUP BY Continent ORDER BY avg(population) DESC LIMIT 1;
-- Find the second most populated country --
SELECT Name, Population FROM Country ORDER BY Population DESC LIMIT 1,1;
-- Show the 5 least populated countries -- 
SELECT Name, Population FROM Country WHERE Population>0 ORDER BY Population ASC LIMIT 5;
-- Find the 5 countries with the lowest life expectancy --
SELECT Name,Lifeexpectancy FROM Country WHERE NOT Lifeexpectancy="null" ORDER BY Lifeexpectancy ASC Limit 5;
-- Show the region with the maximum number of countries --
SELECT Region, count(*) AS No_of_Countries FROM Country group by region ORDER BY No_of_Countries DESC Limit 1;
-- Find all countries with surface area larger than the average surface area --
SELECT Name,SurfaceArea FROM country WHERE SurfaceArea>(SELECT avg(SurfaceArea) FROM COUNTRY);
-- List the Top 10 Cities by Population --
SELECT Name,Population FROM city ORDER BY Population DESC Limit 10;
-- Find the City with the smallest population --
SELECT name,Population FROM city WHERE population=(SELECT min(population) FROM city);
-- Show the most population city in the world --
SELECT name,Population FROM city WHERE population=(SELECT max(population) FROM city);
-- Find the second largest city by population --
SELECT name,Population FROM city ORDER BY population DESC Limit 1,1;
-- Show all countries where the government form includes the word 'Monarchy' --
SELECT * FROM country WHERE GovernmentForm Like '%Monarchy%';
-- List all Countries where official language is English --
SELECT C.code,C.Name,CL.Language,CL.IsOfficial FROM country AS C JOIN countrylanguage AS CL ON C.CODE=CL.CountryCode WHERE CL.Language = 'English' AND CL.IsOfficial='T';
-- Find the number of countries per continent --
SELECT Continent, count(name) AS No_of_Countries FROM country GROUP BY Continent;
-- Show the Average life expectancy per region --
SELECT Region,avg(LifeExpectancy) FROM Country GROUP BY Region;
-- Find the total population of the world --
SELECT sum(population) AS TOTAL_POPULATION FROM country;
-- Show the top 5 most densely populated countries (population/surface area)-- 
SELECT Name,(population/surfaceArea) AS Density FROM Country ORDER BY Density DESC LIMIT 5;
-- Find countries with a population greater than Canada --
SELECT Name,Population FROM Country WHERE Population>(SELECT Population FROM Country WHERE Name = 'Canada');
-- Show the top 5 countries with the largest surface area --
SELECT name,surfaceArea FROM country ORDER BY SurfaceArea DESC LIMIT 5;