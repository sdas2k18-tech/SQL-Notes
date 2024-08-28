create database Demo1

create table emp_compensation (
emp_id int,
salary_component_type varchar(20),
val int
);

select * from emp_compensation;

insert into emp_compensation
values (1,'salary',10000),(1,'bonus',5000),(1,'hike_percent',10)
, (2,'salary',15000),(2,'bonus',7000),(2,'hike_percent',8)
, (3,'salary',12000),(3,'bonus',6000),(3,'hike_percent',7);
select * from emp_compensation;

// sum with case would not give the null values while pivoting from row tabele to columen table 
// cannot into use into keyword directly for making the new table 
// Database System: Different SQL databases handle INTO differently. For instance:

-- In Microsoft SQL Server and PostgreSQL, INTO is used to create a new table and insert data into it.
-- In MySQL and SQLite, INTO is not supported in this way for table creation. You would need to use a CREATE TABLE statement before running an INSERT INTO query. 

CREATE or replace TABLE emp_compensation_pivot (
    emp_id INT,
    salary DECIMAL(10, 2),
    bonus DECIMAL(10, 2),
    hike_percent DECIMAL(5, 2)
);

INSERT INTO emp_compensation_pivot (emp_id, salary, bonus, hike_percent)
SELECT emp_id, 
    SUM(CASE WHEN salary_component_type = 'salary' THEN val ELSE 0 END) AS salary,
    SUM(CASE WHEN salary_component_type = 'bonus' THEN val ELSE 0 END) AS bonus,
    SUM(CASE WHEN salary_component_type = 'hike_percent' THEN val ELSE 0 END) AS hike_percent
FROM emp_compensation
GROUP BY emp_id;



-- in case of mysql servers 
-- select emp_id, 
-- sum(case when salary_component_type = 'salary' then val end) as salary,
-- sum(case when salary_component_type = 'bonus' then val end) as bonus,
-- sum(case when salary_component_type = 'hike_percent' then val end) as hike_percent
-- into emp_compensation_pivot
-- from emp_compensation
-- group by emp_id

select * from emp_compensation_pivot

// unpivoting
select * from (
select emp_id, 'salary' as salary_component_type, salary as val from emp_compensation_pivot
union all
select emp_id, 'bonus' as salary_component_type, bonus as val from emp_compensation_pivot
union all
select emp_id, 'hike_percent' as salary_component_type, hike_percent as val from emp_compensation_pivot
)
order by emp_id


