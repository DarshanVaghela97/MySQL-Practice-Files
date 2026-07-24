CREATE DATABASE COLUMN_ALL_DATA_TYPE;
USE COLUMN_ALL_DATA_TYPE;

/*
1. Numeric Data Types
	-> INT (Integer)
		Example: 10

	-> FLOAT (Floating Point)
		Example: 10.5

	-> DOUBLE (Double Precision Floating Point)
		Example: 123.456   

	-> DECIMAL (Fixed-Point Number)
		Example: 12345.67

	-> TINYINT (Small Integer)
		Example: 1

	-> SMALLINT (Small Integer)
		Example: 32000

	-> BIGINT (Large Integer)
		Example: 123456789012345

2. String Data Types
	-> CHAR (Fixed Length String)
		Example: 'A'

	-> VARCHAR (Variable Length String)
		Example: 'Hello World'

	-> TEXT (Large Text)
		Example: 'This is a large text data type example'

	-> ENUM (Enumeration)
		Example: 'small', 'medium', 'large' (when defined as ENUM('small', 'medium', 'large'))

	-> SET (String Object That Can Have 0 or More Values)
		Example: 'a,b,c' (when defined as SET('a', 'b', 'c'))

	-> BINARY (Fixed Length Binary String)
		Example: 0b01010101

	-> VARBINARY (Variable Length Binary String)
		Example: 0x4d7953514c

3. Date and Time Data Types
	-> DATE (Date Only)
		Example: '2024-09-01'

	-> DATETIME (Date and Time)
		Example: '2024-09-01 12:34:56'

	-> TIMESTAMP (Date and Time, with Time Zone Support)
		Example: '2024-09-01 12:34:56'

	-> TIME (Time Only)
		Example: '12:34:56'

	-> YEAR (Year Only)
		Example: 2024

4. Boolean Data Type
	-> BOOLEAN (Alias for TINYINT(1))
		Example: TRUE or FALSE (which is stored as 1 or 0)
5. Binary Data Types
	-> BLOB (Binary Large Object)
		Example: Binary data, like an image or file, stored in binary form
6. Spatial Data Types
	-> POINT (Stores a Single Location in Coordinate Space)
		Example: POINT(1 1)

	-> LINESTRING (Stores a Line)
		Example: LINESTRING(1 1, 2 2, 3 3)

	-> POLYGON (Stores a Polygon)
		Example: POLYGON((1 1, 2 2, 3 3, 1 1))

7. JSON Data Type
	-> JSON (Stores JSON Objects)
		Example: '{ "name": "John", "age": 30, "city": "New York" }'
8. UUID Data Type
	-> UUID (Stores Universally Unique Identifiers)
		Example: '550e8400-e29b-41d4-a716-446655440000'
9. Bit Data Types
	-> BIT (Bit-Field Type)
		Example: b'101'
*/

CREATE TABLE all_data_types_example (
    int_value INT PRIMARY KEY,
    float_value FLOAT,
    double_value DOUBLE,
    decimal_value DECIMAL(10, 2),
    tinyint_value TINYINT,
    smallint_value SMALLINT,
    bigint_value BIGINT,
    
    char_value CHAR(1),
    varchar_value VARCHAR(255),
    text_value TEXT,
    enum_value ENUM('small', 'medium', 'large'),
    set_value SET('a', 'b', 'c'),
    binary_value BINARY(8),
    varbinary_value VARBINARY(255),
    
    date_value DATE,
    datetime_value DATETIME,
    timestamp_value TIMESTAMP,
    time_value TIME,
    year_value YEAR,
    
    boolean_value BOOLEAN,
    
    blob_value BLOB,
    
    point_value POINT,
    linestring_value LINESTRING,
    polygon_value POLYGON,
    
    json_value JSON,
    uuid_value CHAR(36), 
    
    bit_value BIT(8)
);

SELECT * FROM all_data_types_example;
DESCRIBE all_data_types_example;
DESC all_data_types_example;

INSERT INTO all_data_types_example (
    int_value, float_value, double_value, decimal_value, tinyint_value, smallint_value, bigint_value, 
    char_value, varchar_value, text_value, enum_value, set_value, binary_value, varbinary_value, 
    date_value, datetime_value, timestamp_value, time_value, year_value, boolean_value, blob_value, 
    point_value, linestring_value, polygon_value, json_value, uuid_value, bit_value
) VALUES (
    1, 
    10.5, 
    123.456, 
    12345.67, 
    1, 
    32000, 
    123456789012345, 
    
    'A', 
    'Hello World', 
    'This is a large text data type example', 
    'medium', 
    'a,b,c', 
    b'01010101', 
    0x4d7953514c, 
    
    '2024-09-01', 
    '2024-09-01 12:34:56', 
    CURRENT_TIMESTAMP, 
    '12:34:56', 
    2024, 
    
    TRUE, 
    
    '0101010101010101', 
    
    ST_GeomFromText('POINT(1 1)'), 
    ST_GeomFromText('LINESTRING(1 1, 2 2, 3 3)'), 
    ST_GeomFromText('POLYGON((1 1, 2 2, 3 3, 1 1))'), 
    
    '{ "name": "John", "age": 30, "city": "New York" }', 
    '550e8400-e29b-41d4-a716-446655440000', 
    
    b'10101010'
);

SELECT * FROM all_data_types_example;
