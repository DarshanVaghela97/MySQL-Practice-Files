CREATE DATABASE Assignment;
USE Assignment;

SELECT * FROM raw_customer;

CREATE TABLE staging_customer AS 
SELECT * FROM raw_customer;

SELECT * FROM staging_customer;

-- FIND IF THERE ARE SPACE AT START OR END for all columns --
SELECT customer_id, name, LENGTH(name) AS name_length, LENGTH(TRIM(name)) AS trimmed_length
FROM staging_customer;
SELECT customer_id, email, LENGTH(email) AS email_length, LENGTH(TRIM(email)) AS trimmed_length
FROM staging_customer;
SELECT customer_id, phone, LENGTH(phone) AS phone_length, LENGTH(TRIM(phone)) AS trimmed_length
FROM staging_customer;
SELECT customer_id, address, LENGTH(address) AS address_length, LENGTH(TRIM(address)) AS trimmed_length
FROM staging_customer;

-- Fix The Name Column --
SELECT customer_id,(CASE 
	WHEN name LIKE '%,%' 
    THEN CONCAT(TRIM(SUBSTRING_INDEX(name, ',', -1)), ' ', SUBSTRING_INDEX(name, ',', 1))
    ELSE name
    END)
FROM staging_customer;

UPDATE staging_customer
SET name = CASE 
    WHEN name LIKE '%,%' 
    THEN CONCAT(TRIM(SUBSTRING_INDEX(name, ',', -1)), ' ', SUBSTRING_INDEX(name, ',', 1))
    ELSE name
END;

-- Complete the email ID --
SELECT email,(CASE
	WHEN Email LIKE '%@'
    THEN concat(email,'example.com')
    ELSE Email
END)
FROM staging_customer;

UPDATE staging_customer
SET email = CASE
	WHEN Email LIKE '%@'THEN 
    concat(email,'example.com')
    ELSE Email
END;

SELECT * FROM staging_customer;
DESCRIBE staging_customer;


-- Update and modify date columns --
SELECT customer_id, join_date
FROM staging_customer
WHERE join_date REGEXP '^ *$';

SELECT customer_id, last_purchase
FROM staging_customer
WHERE last_purchase REGEXP '^ *$';

UPDATE staging_customer
SET join_date = NULLIF(TRIM(join_date), ''),
    last_purchase = NULLIF(TRIM(last_purchase), '');
    
UPDATE staging_customer
SET 
join_date = str_to_date(TRIM(JOIN_DATE),'%d-%m-%Y'),
last_purchase = str_to_date(TRIM(last_purchase),'%d-%m-%Y');


ALTER TABLE staging_customer
MODIFY COLUMN join_date DATE,
MODIFY COLUMN last_purchase DATE;

ALTER TABLE staging_customer
MODIFY COLUMN customer_id INT;

-- Name format corrected --
-- uncomplete emails ID fixed --
-- Date convert to string to date and moedified column type --

SELECT * FROM staging_customer;
DESCRIBE staging_customer;

-- change type of purchase_total from TEXT to DECIMAL. First removed any empty spaces --
UPDATE staging_customer
SET purchase_total = NULL
WHERE TRIM(purchase_total) = '';

ALTER TABLE staging_customer
MODIFY COLUMN purchase_total DECIMAL(10,2);

SELECT * FROM staging_customer;

-- Make Phone numbers same format --
SELECT (CASE 
	WHEN phone LIKE '(%' THEN 
		CONCAT(
        SUBSTRING_INDEX(SUBSTRING_INDEX(PHONE, '(', -1), ')', 1),
        '-',
        SUBSTRING_INDEX(phone, ') ', -1)
        )
        ELSE phone
	END) AS phone
   FROM staging_customer;     

UPDATE staging_customer
SET phone = CASE
    WHEN phone LIKE '(%' THEN 
        CONCAT(
            SUBSTRING_INDEX(SUBSTRING_INDEX(phone, '(', -1), ')', 1),
            '-',
            SUBSTRING_INDEX(phone, ') ', -1)
        )
    ELSE phone
END;


-- Removing 8 and 10 as everything is empty --
DELETE FROM staging_customer
WHERE customer_id IN (8, 10);

 SELECT * FROM staging_customer;
 
 -- changing empty spaces to null --
UPDATE staging_customer
SET email = NULL
WHERE TRIM(email) = '';

UPDATE staging_customer
SET address = NULL
WHERE TRIM(address) = '';

-- Making new table and importing Cleaned data --
CREATE TABLE IF NOT EXISTS Customer
AS SELECT * FROM staging_customer;

SELECT * FROM Customer;
DESCRIBE Customer;
