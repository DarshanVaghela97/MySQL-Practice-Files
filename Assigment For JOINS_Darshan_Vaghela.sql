-- 1. Display the film title and its language (film + language) --
SELECT f.title,l.name FROM Film f JOIN Language l ON f.language_id=l.language_id;

-- 2. List the actor names and the films they acted in (actor + film_actor + film) --
SELECT concat(First_name,' ',Last_Name)AS Full_Name,title FROM FILM 
JOIN film_actor ON Film.Film_id = film_actor.Film_id
JOIN Actor ON Actor.Actor_id = Film_actor.Actor_id;

-- 3.Show the customer name and their rental dates (customer + rental) --
SELECT concat(C.First_name,' ',C.Last_Name)AS Full_Name,Rental_Date FROM Customer C  JOIN Rental R ON C.Customer_id = R.Customer_ID;

-- 4.Find the customer name and payment amount (customer + payment) --
SELECT concat(C.First_name,' ',C.Last_Name)AS Full_Name,sum(amount) AS Total_Amount FROM Customer C 
JOIN Payment P ON C.Customer_id = P.Customer_ID GROUP BY Full_Name;

-- 5.Display the store ID and its manager name (store + staff). --
SELECT concat(ST.First_name,' ',ST.Last_Name)AS Manager_Name,S.store_id FROM Store S JOIN STAFF ST ON S.manager_staff_id = ST.staff_id;

-- 6.List the film title and category name (film + film_category + category) --
SELECT f.title,C.name FROM Film F
JOIN Film_category FC ON F.film_id=FC.Film_id
JOIN Category C ON FC.Category_id=C.category_id;

-- 7.Show all rentals with film title and customer name (rental + inventory + film + customer) --
SELECT R.Rental_id,F.title,concat(C.First_name,' ',C.Last_Name)AS Full_Name FROM Rental R
JOIN Customer C ON C.Customer_ID = R.Customer_ID
JOIN Inventory I ON I.inventory_id = R.inventory_id
JOIN Film F ON F.film_id = I.film_id;

-- 8. Find the city and country for each customer (customer + address + city + country) --
SELECT concat(C.First_name,' ',C.Last_Name)AS Full_Name,CT.City,CN.Country FROM Customer C 
JOIN ADDRESS A ON C.address_id = A.address_id
JOIN CITY CT ON A.city_Id = CT.City_id
JOIN Country CN ON CT.country_id = CN.Country_ID;

-- 9.Display all films and the actors who acted in them, ordered by film title. --
SELECT F.Title,concat(A.first_name,' ',A.Last_name) AS Actor_Name FROM Film F
JOIN Film_Actor FA ON FA.film_id = F.Film_id
JOIN Actor A ON A.actor_id = FA.actor_id
ORDER BY f.Title;

-- 10.Show all films that have not been rented yet (use LEFT JOIN with rental) --
SELECT F.title,R.rental_id
FROM Film F
LEFT JOIN Inventory I ON F.film_id = I.film_id
LEFT JOIN Rental R ON I.inventory_id = R.inventory_id
WHERE R.rental_id IS NULL;

-- 11.Display the city name and country name (city + country) --
SELECT CT.name,CN.name FROM CITY CT 
JOIN Country CN ON CT.CountryCode = CN.Code;

-- 12.List the official languages spoken in each country (country + countrylanguage) --
SELECT L.Language,CN.name FROM CountryLanguage L 
JOIN Country CN ON L.countrycode = CN.Code;

-- 13.Find the continent and its countries (country + continent field) --
SELECT Name, Continent FROM Country; 

 -- 14. Show the top 10 most populated cities along with their country name --
 SELECT CT.name,CT.Population,CN.Name FROM City CT
 JOIN Country CN ON CT.CountryCode = CN.Code 
 ORDER BY CT.Population DESC LIMIT 10;
 
 -- 15. List all countries that do not have an official language defined (LEFT JOIN with countrylanguage) --
SELECT CN.Name, L.Language,CN.Code,L.CountryCode,L.IsOfficial
FROM Country CN
LEFT JOIN CountryLanguage L ON L.CountryCode = CN.Code
AND L.IsOfficial = 'T'
WHERE L.CountryCode IS NULL;

-- 16.Show the country name and its capital city (country + city) --
SELECT CT.Name,CN.Name FROM City CT 
JOIN Country CN ON CT.ID = CN.Capital;

-- 17. Display all countries and their regions --
SELECT Name, Region FROM Country;

-- 18.Find the country and languages where population > 50 million. --
SELECT CN.Name, CL.Language,CN.Population FROM Country CN
JOIN CountryLanguage CL ON CN.Code = CL.CountryCode
WHERE CN.Population > 50000000; 

-- 19. List all countries that share the same region (SELF JOIN on country) --
SELECT C1.Name AS Country1,
       C2.Name AS Country2,
       C1.Region
FROM Country C1
JOIN Country C2 ON C1.Region = C2.Region AND C1.Code <> C2.Code;

-- 20. Show the cross join between continent and distinct government forms. --
SELECT C.Continent, G.GovernmentForm
FROM
    (SELECT DISTINCT Continent FROM Country) C
CROSS JOIN
    (SELECT DISTINCT GovernmentForm FROM Country) G;
