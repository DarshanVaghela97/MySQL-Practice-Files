CREATE DATABASE MOVIES;
USE MOVIES;

CREATE TABLE Role_Mapping (
movie_id VARCHAR(12),
name_id VARCHAR(12),
category ENUM('actor','actress')
);

LOAD DATA INFILE 'F:/BIT TRAINING/MySQL/imdb DATA/role_mapping.csv'
INTO TABLE Role_Mapping
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SELECT * FROM Role_Mapping;

CREATE TABLE Actors (
Id VARCHAR(12) PRIMARY KEY,
`Name` VARCHAR(50),
Height VARCHAR(10),
Date_of_Birth VARCHAR(10),
Known_For_Movies VARCHAR(50)
);

LOAD DATA INFILE 'F:/BIT TRAINING/MySQL/imdb DATA/names.csv'
INTO TABLE Actors
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SELECT * FROM Actors;

CREATE TABLE Movies (
Id VARCHAR(12) PRIMARY KEY,
Title VARCHAR(150),
`YEAR` INT,
Date_Published VARCHAR(10),
Duration INT,
Country VARCHAR(240),
Worldwide_gross_income VARCHAR(50),
Languages VARCHAR(240),
Production_Company VARCHAR(240)
);

LOAD DATA INFILE 'F:/BIT TRAINING/MySQL/imdb DATA/movies.csv'
INTO TABLE Movies
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SELECT * FROM Movies;

ALTER TABLE movies
ADD Column Publish_Date Date AFTER Date_Published;
UPDATE movies
SET Publish_Date = STR_TO_DATE(Date_Published,'%m/%d/%Y');
ALTER TABLE movies 
DROP COLUMN Date_Published;

CREATE TABLE Genre (
movie_id VARCHAR(12),
Genre VARCHAR(50)
);

LOAD DATA INFILE 'F:/BIT TRAINING/MySQL/imdb DATA/genre.csv'
INTO TABLE Genre
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SELECT * FROM Genre;

CREATE TABLE Ratings (
movie_id VARCHAR(12) PRIMARY KEY,
Avg_Rating DECIMAL(5,1),
Total_Votes INT,
Median_Rating DECIMAL(5,1)
);

LOAD DATA INFILE 'F:/BIT TRAINING/MySQL/imdb DATA/ratings.csv'
INTO TABLE Ratings
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SELECT * FROM Ratings;

CREATE TABLE Director_Mapping (
movie_id VARCHAR(12),
name_id VARCHAR(12)
);

LOAD DATA INFILE 'F:/BIT TRAINING/MySQL/imdb DATA/director_Mapping.csv'
INTO TABLE Director_Mapping
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
 
 
SELECT * FROM Role_Mapping;
SELECT * FROM Actors;
SELECT * FROM Movies;
SELECT * FROM Genre;
SELECT * FROM Ratings;
SELECT * FROM Director_Mapping;

-- 1) Write SQL Query to find name and year of the movies.Return movie title and movie release year --
SELECT Title,Year FROM Movies;

-- 2) Write SQL Query to find when the movie 'Secret Superstar' was released. Return movie release year --
SELECT Title,Year FROM Movies WHERE Title = 'Secret Superstar';

-- 3) Write SQL Query to find the movie that was released in 2017. Return movie title. --
SELECT Title,Year FROM Movies WHERE YEAR = 2017;

-- 4) Write SQL Query to find movies released before 2019. Return movie title --
SELECT Title,Year FROM Movies WHERE YEAR <2019;

-- 5) Write SQL Query to find all Movie_ID who have Avg_Rating Seven or More stars to their rating --
SELECT Movie_id,Avg_Rating FROM Ratings WHERE Avg_Rating>=7;

-- 6) Find movie titles that contain the letters 'll'. Sort ascending by movie year.--
SELECT Id,Title,Year FROM Movies WHERE title LIKE '%ll%' ORDER BY YEAR ASC;

-- 7) Find those Actors with the first name 'A' and the last name 'A' and the Movies_ID they are known for.
SELECT ID,Name,Known_For_Movies FROM ACTORS WHERE Name LIKE "A% A%";

-- 8) Q-8: Write a SQL query to find the movies with ID 'tt3405236' or tt5764024' tt7820846'.
SELECT Id,Title FROM movies WHERE ID IN ('tt3405236','tt5764024','tt7820846');

-- 9) What Genre of Movies are their in the Data set --
SELECT DISTINCT(Genre) FROM Genre;

-- 10) Show the avg_rating of each movie. Sort result set in descending order by avg_rating --
SELECT M.ID,M.Title,R.avg_rating AS Average_Rating FROM Movies M JOIN Ratings R ON M.ID = R.movie_id
ORDER BY Average_Rating DESC;

-- 11) Find the total Number of movies released each year.
SELECT YEAR,count(ID) AS Number_of_Movies_Released FROM Movies GROUP BY YEAR;

-- 12) How Many movies were produced in the year 2019 --
SELECT YEAR,count(ID) AS Number_of_Movies_Released FROM Movies 
WHERE YEAR = 2019 
GROUP BY YEAR;

-- 13) Which genre has the highest number of movies produced overall --
SELECT Genre,Count(movie_id) AS Number_of_Movies 
FROM Genre 
GROUP BY Genre 
ORDER BY Number_of_Movies DESC 
LIMIT 1;

-- 14) What is the average duration of movies in each genre --
SELECT G.Genre,Avg(M.Duration) AS Average_Duration 
FROM Genre G JOIN Movies M ON G.movie_id = M.ID
GROUP BY G.Genre;

-- 15) Find the minimum and maximum values in each column of the ratings table except the movie_id column 
SELECT 
	max(Avg_rating) AS MAXIMUM_AVG_RATING, min(Avg_rating) AS MINIMUM_AVG_RATING,
	max(Total_Votes) AS MAXIMUM_TOTAL_VOTES, min(Total_Votes) AS MINIMUM_TOTAL_VOTES,
	max(Median_Rating) AS MAXIMUM_MEDIAN_RATING, min(Median_Rating) AS MINIMUM_MEDIAN_RATING
FROM Ratings;

-- 16) How many movies were released in each genre during March 2018 and had votes of more than 1000 --
SELECT Genre,Count(Id) AS Number_of_Movies_Released FROM (
	SELECT G.Genre,M.id,M.publish_date,R.Total_Votes FROM Movies m
	JOIN Ratings R ON M.id = R.movie_id
	JOIN Genre G ON M.id = G.movie_id
	WHERE (M.publish_date BETWEEN '2018-03-01'AND '2018-03-31') 
	AND
	R.Total_Votes>1000
) AS NEW_TABLE
GROUP BY Genre;

-- 17)Find movies of each genre that start with the word Ba and which have an average rating > 7 --
SELECT M.title,G.Genre,R.Avg_rating FROM movies M 
JOIN Genre G ON M.id = G.movie_id
JOIN Ratings R ON M.id = R.movie_id
WHERE M.title LIKE 'Ba%'
AND R.Avg_rating >7.0;

-- 18) No. of Movies released between 1 April 2018 and 1 April 2019, How many were given a median rating of 8 --
SELECT Count(M.id) AS Number_of_Movies FROM Movies m
JOIN Ratings R ON M.id = R.movie_id
WHERE (M.publish_date BETWEEN '2018-04-01'AND '2019-04-01') 
AND 
R.Median_Rating = 8.0;

-- 19) Summarise the ratings table based on the movie counts by median ratings
SELECT Median_Rating, count(movie_id) AS Movie_Count
FROM ratings
GROUP BY median_rating
ORDER BY Median_Rating DESC;

-- 20) Who are the top two actors whose movies have a median rating >= 8 --
SELECT RM.name_id, A.name, COUNT(RM.movie_id) AS Movie_Count
FROM Role_Mapping RM
JOIN Ratings R ON RM.movie_id = R.movie_id
JOIN Actors A ON A.id = RM.name_id
WHERE R.Median_Rating >= 8
GROUP BY RM.name_id
ORDER BY Movie_Count DESC
LIMIT 2;

-- 21) What is the rank of the 'thriller' genre of movies among all the genres in terms of number of movies produced --
SELECT * FROM (
SELECT Genre,Count(movie_id) AS Number_of_Movies,
RANK() OVER(ORDER BY Count(movie_id) DESC) AS RANKING
FROM Genre GROUP BY Genre
) AS RANK_TABLE
WHERE Genre = 'Thriller';

-- 22) Which are the top 10 movies based on average rating?
SELECT * FROM (
SELECT m.title,r.avg_rating,
DENSE_RANK() OVER(ORDER BY R.Avg_Rating DESC) AS RANKING
FROM Movies M
JOIN Ratings R ON M.id = R.movie_id
ORDER BY Avg_Rating DESC
) AS RANKING
WHERE RANKING <11;

-- 23) Which production house has produced the most number of hit movies (average rating > 7) --
SELECT M.Production_company,count(M.id) AS Number_of_Movies FROM movies M
JOIN Ratings R ON M.id = R.movie_id
WHERE M.Production_company IS NOT NULL 
AND M.Production_Company != ''
AND R.Avg_rating > 7
GROUP BY M.Production_company
ORDER BY Number_of_Movies DESC
LIMIT 1;

-- 24) Which are the top three production houses based on the number of votes received by their movies --
SELECT M.Production_company,sum(R.Total_Votes) AS Total_Votes FROM movies M
JOIN Ratings R ON M.id = R.movie_id
WHERE M.Production_company IS NOT NULL 
AND M.Production_Company != ''
GROUP BY M.Production_company
ORDER BY Total_Votes DESC
LIMIT 3;

-- 25) Rank actors based on their average ratings --
SELECT A.Name,avg(R.Avg_Rating) AS AVG_RATINGS, 
DENSE_RANK () OVER(ORDER BY avg(R.Avg_Rating) DESC) AS RANKING
FROM role_mapping RM
JOIN Actors A ON A.ID = RM.Name_id
JOIN Ratings R ON R.movie_id = RM.movie_id
GROUP BY A.Name;

-- 26) FIND out the Top 5 actresses based on their average ratings
SELECT Name,Category,AVG_RATINGS,RANKING FROM 
(
	SELECT A.Name,RM.category,avg(R.Avg_Rating) AS AVG_RATINGS,
	DENSE_RANK () OVER(ORDER BY avg(R.Avg_Rating) DESC) AS RANKING
	FROM role_mapping RM
	JOIN Actors A ON A.ID = RM.Name_id
	JOIN Ratings R ON R.movie_id = RM.movie_id
	WHERE Category = 'Actress'
	GROUP BY A.Name,RM.category
) AS NEW_TABLE
WHERE RANKING <6;

-- 27) Select drama movies as per avg rating and classify them in the following category :
-- Rating > 8 : Superhit Movies
-- Rating between 7 and 8 : Hit Movies
-- Rating between 5 and 7 : One Time watch movies
-- Rating < 5 : Flop Movies

SELECT M.Title, R.Avg_Rating,
    CASE
        WHEN R.Avg_Rating > 8  THEN 'Superhit'
        WHEN R.Avg_Rating >= 7 THEN 'Hit'
        WHEN R.Avg_Rating >= 5 THEN 'One Time Watch'
        ELSE 'Flop'
    END AS Movie_Category
FROM Movies M
JOIN Ratings R ON M.Id = R.movie_id
JOIN Genre G   ON M.Id = G.movie_id
WHERE G.Genre = 'Drama';

-- 28) What is the genre-wise running total and moving average of the average movie duration --
SELECT 
	genre,
    ROUND(AVG(duration),2) AS AVG_Duration,
    SUM(AVG(duration)) OVER (ORDER BY genre) AS Running_Total_Duration,
    AVG(AVG(duration)) OVER (ORDER BY genre) AS Moving_Avg_Duration
FROM Movies M
JOIN Genre G ON M.id = G.Movie_ID
GROUP BY Genre;

-- 29) Which are the five highest grossing movies of each year that belong to the top 2 genre --
/* First REMOVED THE Currency symbol from Worldwide_Gross_Income */
SELECT Worldwide_gross_income AS 'Original_Worldwide_gross_income',
	(CASE 
	WHEN Worldwide_gross_income Like '$%' THEN
    TRIM(SUBSTRING_INDEX(Worldwide_gross_income, '$',-1))
    WHEN TRIM(Worldwide_gross_income) = '' THEN NULL
	ELSE
    Worldwide_gross_income
    END) AS 'Worldwide_gross_income'
FROM movies;

ALTER TABLE movies
ADD COLUMN Worldwide_gross_income_clean BIGINT 
AFTER Worldwide_gross_income;

UPDATE Movies
 SET Worldwide_gross_income_Clean = CASE
	WHEN Worldwide_gross_income Like '$%' THEN
    TRIM(SUBSTRING_INDEX(Worldwide_gross_income, '$',-1))
    WHEN TRIM(Worldwide_gross_income) = '' THEN NULL
	ELSE
    Worldwide_gross_income
    END;

/* Now the Solution for Question 29 */
WITH Top_2_Genre AS (
	SELECT genre, Count(movie_id) AS Movie_Count,
		RANK() OVER (ORDER BY COUNT(Movie_id) DESC) AS genre_rank
	FROM genre
    GROUP BY Genre
    ORDER BY COUNT(movie_id) DESC
    LIMIT 2
),
Movies_Rank AS (
	SELECT 
    G.Genre,
    M.title, 
    M.year, 
    M.Worldwide_gross_income_clean,
		RANK() OVER (PARTITION BY M.Year ORDER BY M.Worldwide_gross_income_clean DESC) AS WorldWide_Income_Rank
	FROM movies AS M
    JOIN Genre AS G
    ON M.ID =G.movie_id
WHERE G.Genre IN (SELECT Genre FROM Top_2_Genre)
)
SELECT *
FROM Movies_Rank
WHERE WorldWide_Income_Rank <=5;

-- 30) Which are the top three production houses that have produced the highest number of hits (median rating >= 8)
SELECT * FROM (
SELECT M.Production_Company,count(M.ID) AS Movie_count,
DENSE_RANK() OVER(ORDER BY count(M.ID) DESC) AS RANKING 
FROM Movies M
JOIN Ratings R ON M.ID = R.movie_id
WHERE (M.Production_Company IS NOT NULL AND M.Production_Company != '')
AND R.Median_Rating >= 8
GROUP BY Production_Company
) AS NEW_TABLE 
WHERE RANKING <4;

-- 31) Who are the top actresses based on a number of super Hit movies (Average Rating > 8) in the drama genre --
SELECT A.Name,count(R.movie_id) AS Movie_Count, 
DENSE_RANK() OVER(ORDER BY count(R.movie_id) DESC) AS RANKING FROM ACTORS A
JOIN role_mapping RM ON RM.Name_id = A.ID
JOIN Ratings R ON RM.movie_id = R.movie_id
JOIN Genre G ON RM.movie_id = G.movie_id
WHERE RM.Category = 'actress' AND R.avg_rating > 8 AND G.Genre = 'Drama'
GROUP BY A.Name;