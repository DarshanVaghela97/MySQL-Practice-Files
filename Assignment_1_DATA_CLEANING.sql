CREATE DATABASE Assignment;
USE Assignment;
SELECT * FROM raw_transactions;

CREATE TABLE staging_transactions AS 
SELECT * FROM raw_transactions;

DESCRIBE raw_transactions;
DESCRIBE staging_transactions;

SELECT * FROM staging_transactions;

SELECT MyUnknownColumn,Count(*) FROM Staging_transactions GROUP BY MyUnknownColumn;

SELECT * FROM staging_transactions 
WHERE customer_name IS NULL AND amount IS NULL;

SELECT * FROM staging_transactions
WHERE currency NOT REGEXP '^[A-Z]{3}$';

-- DELETING THE EMPYTY ROWS --
DELETE FROM staging_transactions 
WHERE transaction_id IN (6,14);


-- FIXING DATE FORMAT BY MAKING NEW COLUMN --
SELECT transaction_date,
CASE 
	WHEN transaction_date LIKE '%/%' THEN STR_TO_DATE(transaction_date, '%m/%d/%Y')
	WHEN transaction_date LIKE '%-%' THEN STR_TO_DATE(transaction_date, '%d-%m-%Y')
	ELSE NULL
    END AS new_date
FROM staging_transactions;

ALTER table staging_transactions
ADD COLUMN Transaction_date_NEW DATE AFTER Transaction_date;

UPDATE staging_transactions
SET Transaction_date_NEW = CASE 
    WHEN transaction_date LIKE '%/%' THEN STR_TO_DATE(transaction_date, '%m/%d/%Y')
	WHEN transaction_date LIKE '%-%' THEN STR_TO_DATE(transaction_date, '%d-%m-%Y')
END;

SELECT * FROM staging_transactions;
describe staging_transactions;

ALTER TABLE staging_transactions
DROP transaction_date;

ALTER TABLE staging_transactions 
RENAME COLUMN Transaction_date_NEW TO Transaction_date;


-- Updating Amount Column row 1 and 5 --
SELECT currency FROM staging_transactions WHERE currency REGEXP '^[A-Z]{3}$';
SELECT currency FROM staging_transactions WHERE currency NOT REGEXP '^[A-Z]{3}$';

SELECT(CASE 
	WHEN currency NOT REGEXP '^[A-Z]{3}$' THEN
    concat(Amount,Currency)
    ELSE amount
    END)
AS Amount,Currency
FROM staging_transactions;

UPDATE staging_transactions
	SET Amount = CASE 
    WHEN Currency NOT REGEXP '^[A-Z]{3}$' THEN
    CONCAT(Amount,Currency)
    ELSE AMOUNT
END;

-- FIXING ROWS 1 and 5 --
SELECT * FROM staging_transactions;
SELECT * FROM raw_transactions;   

SELECT distinct(currency) FROM staging_transactions;

SELECT 
	(CASE 
		WHEN MyUnknownColumn != '' THEN
		description
		ELSE currency
    END) AS 'Corrected Currency',
    (CASE
		WHEN MyUnknownColumn != '' THEN
        status Else
        `Description`
        END) AS 'Corrected Description',
	(CASE
		WHEN MyUnknownColumn != '' THEN
        location Else
        `status`
        END) AS 'Corrected status',
	(CASE
		WHEN MyUnknownColumn != '' THEN
        notes Else
        location
        END) AS 'Corrected location',
	(CASE
		WHEN MyUnknownColumn != '' THEN
        MyUnknownColumn Else
        notes
        END) AS 'Corrected notes'
FROM staging_transactions; 

UPDATE staging_transactions
	SET Currency = CASE 
		WHEN MyUnknownColumn != '' THEN
		description
		ELSE currency
    END,
		`Description` = CASE
		WHEN MyUnknownColumn != '' THEN
        status Else
        `Description`
	END,
		`status` = CASE
		WHEN MyUnknownColumn != '' THEN
        location Else
        `status`
	END,
		location = CASE
		WHEN MyUnknownColumn != '' THEN
        notes Else
        location
	END,
		notes = CASE
		WHEN MyUnknownColumn != '' THEN
        MyUnknownColumn Else
        notes
	END,
		MyUnknownColumn = CASE 
        WHEN MyUnknownColumn != '' THEN
        NULL Else
        MyUnknownColumn
	END;
    
SELECT * FROM staging_transactions;


-- removing currency symbols and formatting Amount column -- 
SELECT amount FROM staging_transactions WHERE amount REGEXP '^[0-9]';
SELECT amount FROM staging_transactions WHERE amount NOT REGEXP '^[0-9]';

SELECT amount AS 'original_amount',
	(CASE 
	WHEN amount regexp'^[0-9]' THEN
    Trim(amount) 
    ELSE
    substring(trim(amount),2)
    END) AS 'amount'
FROM staging_transactions;

UPDATE staging_transactions
	SET amount = CASE
		WHEN amount regexp'^[0-9]' THEN
		trim(amount) 
    ELSE
		substring(trim(amount),2)
END;

-- fixing amount values --

UPDATE staging_transactions
	SET amount = CASE 
		WHEN amount = "1,500.99" THEN "1500.99"
        WHEN amount = "2,75.50" THEN "275.50"
        WHEN amount = "1.250,50" THEN "1250.50"
        WHEN amount = "2'500.00" THEN "2500.00"
        ELSE
        amount
	END;

describe staging_transactions;

ALTER TABLE staging_transactions
MODIFY COLUMN amount DECIMAL(10,2);

ALTER TABLE staging_transactions
MODIFY COLUMN transaction_id INT,
MODIFY COLUMN account_id INT;

ALTER TABLE staging_transactions
DROP COLUMN MyUnknownColumn ;

SELECT * FROM staging_transactions;

-- CREATE NEW TABLE AND IMPORT CLEANED DATA IN IT --

CREATE TABLE Transactions AS
SELECT * FROM staging_transactions;

SELECT * FROM Transactions;
DESCRIBE Transactions;

-- DATA is Clean. All column types are correct. Null values left as original data. Transaction ID 6 and 14 were completely empty so removed the rows --