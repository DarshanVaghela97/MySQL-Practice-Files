CREATE DATABASE COVID_19;
USE COVID_19;

CREATE TABLE Coronavirus (
Province VARCHAR(100),
Country_Region VARCHAR(100),
Latitude DECIMAL (8,5),
Longitude DECIMAL (8,5),
`Date` Date,
Confirmed INT,
Deaths INT,
Recovered INT
);

LOAD DATA INFILE 'F:/BIT TRAINING/MySQL/Coronavirus Data/Corona Virus Dataset.csv'
INTO TABLE Coronavirus
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SELECT * FROM Coronavirus;
DESCRIBE Coronavirus;

-- 1) Write a code to check Null Values --
SELECT * FROM Coronavirus WHERE
Province IS NULL OR
Country_Region IS NULL OR
Latitude IS NULL OR
Longitude IS NULL OR
Date IS NULL OR 
Confirmed IS NULL OR
Deaths IS NULL OR
Recovered IS NULL;

-- 2) If NULL Values are present, Update them with zeros for all columns --
UPDATE Coronavirus
SET 
    Province = COALESCE(Province, '0'),
    Country_Region = COALESCE(Country_Region, '0'),
    Latitude = COALESCE(Latitude, 0),
    Longitude = COALESCE(Longitude, 0),
    `Date` = COALESCE(`Date`, '0000-00-00'),
    Confirmed = COALESCE(Confirmed, 0),
    Deaths = COALESCE(Deaths, 0),
    Recovered = COALESCE(Recovered, 0)
WHERE 
    Province IS NULL 
    OR Country_Region IS NULL 
    OR Latitude IS NULL 
    OR Longitude IS NULL 
    OR `Date` IS NULL 
    OR Confirmed IS NULL 
    OR Deaths IS NULL 
    OR Recovered IS NULL;

-- 3) Check Total Number of ROWS --
SELECT COUNT(*) AS Total_Rows FROM Coronavirus;

-- 4) Check what is Start_Date and End_Date --
SELECT MIN(DATE) AS START_DATE, MAX(DATE) AS END_DATE FROM Coronavirus;

-- 5) Number of Month Present in DATASET.--
SELECT COUNT(DISTINCT(DATE_FORMAT(Date, '%m-%Y'))) AS TOTAL_MONTHS FROM coronavirus;

-- 6) Find Monthly Average for confirmed, deaths, recovered.
SELECT Date_Format(DATE,'%M-%Y') AS Month_Year,
AVG(confirmed) AS Avg_Confirmed_Cases,
AVG(deaths) AS Avg_Deaths,
AVG(recovered) AS Avg_Recovered_Cases
FROM coronavirus GROUP BY Date_Format(DATE,'%M-%Y');

-- 7) Find most frequent values for confirmed,deaths,recovered each month --
SELECT 
EXTRACT(MONTH FROM DATE) AS MONTH,
EXTRACT(YEAR FROM DATE) AS YEAR,
SUBSTRING_INDEX(GROUP_CONCAT(Confirmed
		ORDER BY CONFIRMED DESC),',',1) AS Most_Frequent_Confirmed,
SUBSTRING_INDEX(GROUP_CONCAT(Deaths
		ORDER BY DEATHS DESC),',',1) AS Most_Frequent_Deaths,
SUBSTRING_INDEX(GROUP_CONCAT(Recovered
		ORDER BY RECOVERED DESC),',',1) AS Most_Frequent_RECOVERED
FROM 
CORONAVIRUS
GROUP BY YEAR,MONTH
ORDER BY YEAR,MONTH;

-- 8) Find Minimum Values for confirmed,deaths,recovered per Year --
SELECT DATE_FORMAT(DATE,'%Y') AS YEAR,
MIN(confirmed) AS Min_Confirmed_Cases,
MIN(deaths) AS Min_Deaths,
MIN(recovered) AS Min_Recovered_Cases
FROM coronavirus GROUP BY DATE_FORMAT(DATE,'%Y');

-- 9) Find Maximum Values for confirmed,deaths,recovered per Year --
SELECT DATE_FORMAT(DATE,'%Y') AS YEAR,
MAX(confirmed) AS Max_Confirmed_Cases,
MAX(deaths) AS Max_Deaths,
MAX(recovered) AS Max_Recovered_Cases
FROM coronavirus GROUP BY DATE_FORMAT(DATE,'%Y');

-- 10) Find Total Values for confirmed,deaths,recovered per Year --
SELECT DATE_FORMAT(DATE,'%Y') AS YEAR,
SUM(confirmed) AS Total_Confirmed_Cases,
SUM(deaths) AS Total_Deaths,
SUM(recovered) AS Total_Recovered_Cases
FROM coronavirus GROUP BY DATE_FORMAT(DATE,'%Y');

-- 11) Check how coronavirus spread out w.r.t Confirmed Case (Ex.:Total Confirmed Cases, Their Average Variance & Stdev) --
SELECT 
	SUM(Confirmed) AS Total_Confirmed_Cases,
    AVG(Confirmed) AS Avg_Confirmed_Cases,
    VARIANCE(Confirmed) AS Variance_Confirmed_Cases,
    STDDEV(Confirmed) AS Stdev_Confirmed_Cases
FROM
coronavirus;

-- 12) Check how coronavirus spread out w.r.t Death Case (Ex.:Total Confirmed Cases, Their Average Variance & Stdev) --
SELECT 
	SUM(Deaths) AS Total_Deaths,
    AVG(Deaths) AS Avg_Deaths,
    VARIANCE(Deaths) AS Variance_Deaths,
    STDDEV(Deaths) AS Stdev_Deaths
FROM
coronavirus;

-- 13) Check how coronavirus spread out w.r.t Recovered Case (Ex.:Total Confirmed Cases, Their Average Variance & Stdev) --
SELECT 
	SUM(recovered) AS Total_Recovered_Cases,
    AVG(recovered) AS Avg_Recovered_Cases,
    VARIANCE(recovered) AS Variance_Recovered_Cases,
    STDDEV(recovered) AS Stdev_Recovered_Cases
FROM
coronavirus;

-- 14) Find Country Having Highest Number of Confirmed Case --
SELECT Country_Region,sum(Confirmed) AS Total_Confirmed_Cases 
FROM coronavirus GROUP BY Country_Region
ORDER BY Total_Confirmed_Cases DESC LIMIT 1;


-- 15) Find Country Having Lowest Number of Death Case --
WITH Total_Death_Cases AS (
    SELECT Country_Region, SUM(Deaths) AS Total_Deaths 
    FROM coronavirus 
    GROUP BY Country_Region
)
SELECT Country_Region, Total_Deaths 
FROM Total_Death_Cases
WHERE Total_Deaths = (SELECT MIN(Total_Deaths) FROM Total_Death_Cases);

-- 16) Find Top 5 Countries having Highest Recovered Case --
SELECT Country_Region,sum(recovered) AS Total_Recovered_Cases
FROM Coronavirus GROUP BY COUNTRY_REGION
ORDER BY Total_Recovered_Cases DESC LIMIT 5;