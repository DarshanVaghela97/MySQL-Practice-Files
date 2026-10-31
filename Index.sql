CREATE DATABASE `index`;
USE `index`;

CREATE TABLE Employee (
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100),
    department VARCHAR(50),
    salary INT
);

INSERT INTO Employee (name, email, department, salary) VALUES
('Amit','amit@gmail.com','IT', 50000),
('Rahul','rahul@gmail.com','HR', 40000),
('Sneha','sneha@gmail.com','IT', 60000),
('Priya','priya@gmail.com','Finance', 55000),
('Karan','karan@gmail.com','IT', 45000);

EXPLAIN SELECT * FROM Employee WHERE name = 'Amit';

CREATE INDEX idx_employee_name
ON Employee(name);

SHOW INDEX FROM Employee;

SELECT * FROM Employee;

EXPLAIN SELECT * FROM Employee WHERE name = 'Amit';

CREATE INDEX idx_dept_salary ON Employee(department, salary);

SELECT * FROM Employee WHERE department = 'IT' AND salary > 50000;

CREATE UNIQUE INDEX idx_email ON Employee(email);

DROP INDEX idx_email ON Employee;

SELECT * FROM Employee;

SELECT email, count(*) FROM Employee group by email having count(*) > 1;

SHOW INDEX FROM Employee;

CREATE TABLE IF NOT EXISTS course1(
course_id VARCHAR(40),
course_name VARCHAR(40),
course_desc VARCHAR(40),
course_tag VARCHAR(40),
index(course_id)
);

SHOW INDEX FROM course1;

SELECT * FROM course1;

INSERT INTO course1 VALUES
(101,'fsda','full stack data analytics','analytics'),
(102,'fsds','full stack data analytics','analytics'),
(103,'fsds','full stack data analytics','DS'),
(104,'big data','full stack big data','BD'),
(105,'mern','web dev','mern'),
(106,'blockchain','full stack blockchain','BC'),
(101,'java','full stack java','java'),
(102,'testing','full testing','testing'),
(105,'cybersecurity','full stack cybersecurity','cybersecurity'),
(109,'c','c language','c'),
(108,'c++','c++ language','c++');

create table if not exists course2 (
course_id VARCHAR(40),
course_name VARCHAR(40),
course_desc VARCHAR(40),
course_tag VARCHAR(40),
index(course_id,course_name,course_tag)
);

INSERT INTO course2 VALUES
(101,'fsda','full stack data analytics','analytics'),
(102,'fsds','full stack data analytics','analytics'),
(103,'fsds','full stack data analytics','DS'),
(104,'big data','full stack big data','BD'),
(105,'mern','web dev','mern'),
(106,'blockchain','full stack blockchain','BC'),
(101,'java','full stack java','java'),
(102,'testing','full testing','testing'),
(105,'cybersecurity','full stack cybersecurity','cybersecurity'),
(109,'c','c language','c'),
(108,'c++','c++ language','c++');

EXPLAIN ANALYZE SELECT * FROM COURSE2 WHERE COURSE_ID = 1-6 OR COURSE_NAME = 'fsds';

analyze table course2;
describe course2;

create table if not exists student1(
student_id varchar(40),
student_name varchar(40),
student_desc varchar(40),
student_tag varchar(40)
);

insert into student1 values
(01,'fs','full','ana'),
(02,'ds','full','ana'),
(03,'sd','data','DA'),
(04,'big','f data','DB'),
(05,'mern','dev','N'),
(06,'chain','blockchain','CB'),
(01,'QS','java','SQ'),
(02,'ing','fulling','test'),
(05,'cyber','security','cybers'),
(09,'me','language','cZ'),
(08,'c+','language','c+');

SELECT course_id, course_name from course1
union
select student_id, student_name from student1;

with sample_student as(
SELECT * FROM course1 WHERE course_id IN (101,102,106))
SELECT * FROM sample_student where course_tag = 'java';

with out_cross as
( select c.course_id ,c.course_name, s.student_id, s.student_name from course1 c CROSS JOIN student1 s)
select course_id,course_name,student_id from out_cross where student_id = 2;

with recursive cte1 as
(select 1 as n union all 
select n+1 from cte1 where n<100)
select * from cte1;

with recursive cte as
(select 1 as n,1 as p, -1 as q UNION ALL
select n+1,p+2,q+4 from cte WHERE n<50)
Select * from cte;