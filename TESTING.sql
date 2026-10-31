CREATE TABLE IF NOT EXISTS Assignment_1 
(Transaction_ID INT,
ACCOUNT_ID INT,
Customer_Name VARCHAR(50),
Transaction_Date VARCHAR(20),
Amount VARCHAR(20),
Currency VARCHAR(20),
Description VARCHAR(100),
Status VARCHAR(50),
Location VARCHAR(100),
Notes VARCHAR(100),
UnknownData VARCHAR(100)
);

SELECT * FROM  Assignment_1;

LOAD DATA INFILE "F:/BIT TRAINING/MySQL/4. Assignment SQL Case Statments - Unclean Dataset 1.csv"
INTO TABLE Assignment_1 
CHARACTER SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SELECT * FROM ASSIGNMENT_1;

SELECT(CASE 
	WHEN currency NOT REGEXP '^[A-Z]{3}$' THEN
    concat(Amount,Currency)
    ELSE amount
    END)
AS Amount,Currency
FROM Assignment_1_table;




DROP TABLE IF EXISTS staging_transactions;
DROP TABLE IF EXISTS staging_customers;
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS customers;

CREATE TABLE staging_transactions (
    col1  TEXT,
    col2  TEXT,
    col3  TEXT,
    col4  TEXT,
    col5  TEXT,
    col6  TEXT,
    col7  TEXT,
    col8  TEXT,
    col9  TEXT,
    col10 TEXT,
    col11 TEXT
) CHARACTER SET latin1;

CREATE TABLE staging_customers (
    col1 TEXT,
    col2 TEXT,
    col3 TEXT,
    col4 TEXT,
    col5 TEXT,
    col6 TEXT,
    col7 TEXT,
    col8 TEXT
) CHARACTER SET utf8mb4;

LOAD DATA LOCAL INFILE "F:/BIT TRAINING/MySQL/4. Assignment SQL Case Statments - Unclean Dataset 1.csv"
INTO TABLE staging_transactions
CHARACTER SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11);

LOAD DATA LOCAL INFILE "F:/BIT TRAINING/MySQL/4. Assignment SQL Case Statments - Unclean Dataset 1.csv"
INTO TABLE staging_customers
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(col1, col2, col3, col4, col5, col6, col7, col8);


CREATE TABLE transactions (
    transaction_id   INT NOT NULL,
    account_id       INT,
    customer_name    VARCHAR(255),
    transaction_date DATE,
    amount           DECIMAL(12, 2),
    currency         CHAR(3),
    description      VARCHAR(255),
    status           VARCHAR(50),
    location         VARCHAR(255),
    notes            VARCHAR(255),
    PRIMARY KEY (transaction_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE customers (
    customer_id     INT NOT NULL,
    name            VARCHAR(255),
    email           VARCHAR(255),
    phone           VARCHAR(50),
    address         VARCHAR(255),
    join_date       DATE,
    purchase_total  DECIMAL(10, 2),
    last_purchase   DATE,
    PRIMARY KEY (customer_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


INSERT INTO transactions (
    transaction_id,
    account_id,
    customer_name,
    transaction_date,
    amount,
    currency,
    description,
    status,
    location,
    notes
)
SELECT 
    CAST(col1 AS UNSIGNED) AS transaction_id,
    CASE 
        WHEN TRIM(col2) IN ('', 'NULL') THEN NULL 
        ELSE CAST(TRIM(col2) AS UNSIGNED) 
    END AS account_id,
    CASE 
        WHEN TRIM(col3) IN ('', 'NULL') THEN NULL 
        ELSE TRIM(col3) 
    END AS customer_name,
    CASE 
        WHEN TRIM(col4) IN ('', 'NULL') THEN NULL
        WHEN TRIM(col4) REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$' THEN STR_TO_DATE(TRIM(col4), '%d-%m-%Y')
        WHEN TRIM(col4) REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$' THEN STR_TO_DATE(TRIM(col4), '%m/%d/%Y')
        WHEN TRIM(col4) REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' THEN STR_TO_DATE(TRIM(col4), '%Y-%m-%d')
        ELSE NULL
    END AS transaction_date,
    CAST(
        CASE 
            WHEN (CASE WHEN col7 IN ('USD','EUR','JPY','HUF','GBP','CAD','CNY','CHF') THEN col7 ELSE col6 END) = 'NULL' 
                 OR TRIM(CASE WHEN col7 IN ('USD','EUR','JPY','HUF','GBP','CAD','CNY','CHF') THEN col5 ELSE col5 END) IN ('', 'NULL') 
                 THEN NULL
            WHEN (CASE WHEN col7 IN ('USD','EUR','JPY','HUF','GBP','CAD','CNY','CHF') THEN CONCAT(col5, ',', col6) ELSE col5 END) REGEXP '[0-9]+\\.[0-9]{3},[0-9]{2}' 
                 THEN REPLACE(REPLACE((CASE WHEN col7 IN ('USD','EUR','JPY','HUF','GBP','CAD','CNY','CHF') THEN CONCAT(col5, ',', col6) ELSE col5 END), '.', ''), ',', '.')
            WHEN (CASE WHEN col7 IN ('USD','EUR','JPY','HUF','GBP','CAD','CNY','CHF') THEN CONCAT(col5, ',', col6) ELSE col5 END) LIKE '%''%'
                 THEN REPLACE(REGEXP_REPLACE((CASE WHEN col7 IN ('USD','EUR','JPY','HUF','GBP','CAD','CNY','CHF') THEN CONCAT(col5, ',', col6) ELSE col5 END), '[^0-9.]', ''), '''', '')
            ELSE REPLACE(REGEXP_REPLACE((CASE WHEN col7 IN ('USD','EUR','JPY','HUF','GBP','CAD','CNY','CHF') THEN CONCAT(col5, ',', col6) ELSE col5 END), '[^0-9.,]', ''), ',', '')
        END AS DECIMAL(12, 2)
    ) AS amount,
    NULLIF(TRIM(CASE WHEN col7 IN ('USD','EUR','JPY','HUF','GBP','CAD','CNY','CHF') THEN col7 ELSE col6 END), 'NULL') AS currency,
    NULLIF(TRIM(CASE WHEN col7 IN ('USD','EUR','JPY','HUF','GBP','CAD','CNY','CHF') THEN col8 ELSE col7 END), '') AS description,
    NULLIF(TRIM(CASE WHEN col7 IN ('USD','EUR','JPY','HUF','GBP','CAD','CNY','CHF') THEN col9 ELSE col8 END), 'NULL') AS status,
    NULLIF(TRIM(CASE WHEN col7 IN ('USD','EUR','JPY','HUF','GBP','CAD','CNY','CHF') THEN col10 ELSE col9 END), 'NULL') AS location,
    NULLIF(TRIM(REPLACE(CASE WHEN col7 IN ('USD','EUR','JPY','HUF','GBP','CAD','CNY','CHF') THEN col11 ELSE col10 END, '\r', '')), '') AS notes
FROM staging_transactions
WHERE col1 IS NOT NULL AND TRIM(col1) != '';

INSERT INTO customers (
    customer_id,
    name,
    email,
    phone,
    address,
    join_date,
    purchase_total,
    last_purchase
)
SELECT 
    CAST(col1 AS UNSIGNED) AS customer_id,
    CASE 
        WHEN TRIM(col2) IN ('', 'NULL') THEN NULL
        WHEN TRIM(col2) LIKE '%, %' THEN CONCAT(SUBSTRING_INDEX(TRIM(col2), ', ', -1), ' ', SUBSTRING_INDEX(TRIM(col2), ', ', 1))
        ELSE TRIM(col2)
    END AS name,
    CASE 
        WHEN TRIM(col3) IN ('', 'NULL') THEN NULL
        ELSE TRIM(col3)
    END AS email,
    CASE 
        WHEN TRIM(col4) IN ('', 'NULL') THEN NULL
        ELSE TRIM(col4)
    END AS phone,
    CASE 
        WHEN TRIM(col5) IN ('', 'NULL') THEN NULL
        ELSE TRIM(col5)
    END AS address,
    CASE 
        WHEN TRIM(col6) IN ('', 'NULL') THEN NULL
        WHEN TRIM(col6) REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$' THEN STR_TO_DATE(TRIM(col6), '%d-%m-%Y')
        WHEN TRIM(col6) REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$' THEN STR_TO_DATE(TRIM(col6), '%m/%d/%Y')
        WHEN TRIM(col6) REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' THEN STR_TO_DATE(TRIM(col6), '%Y-%m-%d')
        ELSE NULL
    END AS join_date,
    CASE 
        WHEN TRIM(col7) IN ('', 'NULL') THEN NULL
        ELSE CAST(TRIM(col7) AS DECIMAL(10,2))
    END AS purchase_total,
    CASE 
        WHEN TRIM(col8) IN ('', 'NULL') THEN NULL
        WHEN TRIM(col8) REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$' THEN STR_TO_DATE(TRIM(col8), '%d-%m-%Y')
        WHEN TRIM(col8) REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$' THEN STR_TO_DATE(TRIM(col8), '%m/%d/%Y')
        WHEN TRIM(col8) REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' THEN STR_TO_DATE(TRIM(col8), '%Y-%m-%d')
        ELSE NULL
    END AS last_purchase
FROM staging_customers
WHERE col1 IS NOT NULL AND TRIM(col1) != '';

DROP TABLE IF EXISTS staging_transactions;
DROP TABLE IF EXISTS staging_customers;

DESCRIBE transactions;
SELECT * FROM transactions;

DESCRIBE customers;
SELECT * FROM customers;
