/* query to create database name employeedatabase */
CREATE DATABASE employeedatabase;
/*query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT
from the employee record table*/
use employeedatabase;
SELECT EMP_ID,FIRST_NAME,LAST_NAME,GENDER,DEPT
from emp_record_table;
/*query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and
EMP_RATING if the EMP_RATING is less than two*/
SELECT EMP_ID,FIRST_NAME,LAST_NAME,GENDER,DEPT,EMP_RATING
from emp_record_table
where emp_rating < 2;
/*query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and
EMP_RATING if the EMP_RATING is greater than 4*/
SELECT EMP_ID,FIRST_NAME,LAST_NAME,GENDER,DEPT,EMP_RATING
from emp_record_table
where emp_rating > 4;
/*query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and
EMP_RATING if the EMP_RATING is between 2 and 4*/
SELECT EMP_ID,FIRST_NAME,LAST_NAME,GENDER,DEPT,EMP_RATING
from emp_record_table
where emp_rating BETWEEN 2 AND 4;
/*query to concatenate the FIRST_NAME and the LAST_NAME of employees in
the Finance department from the employee table and then give the resultant
column alias as NAME*/
SELECT *, CONCAT(FIRST_NAME, LAST_NAME) AS NAME 
FROM emp_record_table
where dept="finance";
/* query to to list only those employees who have someone reporting to them.
 Also, show the number of reporters (including the President). */
 SELECT emp_id,first_name,last_name,role,dept, count(role)over (partition by role) as number_of_reporters
 from emp_record_table
 where role in ("PRESIDENT","MANAGER","LEAD DATA SCIENTIST","SENIOR DATA SCIENTIST");
 /* query to list down all the employees from the healthcare and finance departments using union. 
 Take data from the employee record table.*/
 SELECT emp_id,first_name,last_name,dept
 from emp_record_table
 where dept="finance"
 UNION
 SELECT emp_id,first_name,last_name,dept
 from emp_record_table
 where dept="healthcare";
 /* query to list down employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, and EMP_RATING grouped by dept. 
 Also include the respective employee rating along with the max emp rating for the department.*/
SELECT emp_id, first_name,last_name,role,dept,emp_rating,max(emp_rating) over (Partition by dept order by emp_rating DESC)As MAX_emp_rating 
from emp_record_table;
/* query to calculate the minimum and the maximum salary of the employees
in each role*/
Select role,Max(salary),Min(salary)
from emp_record_table
group by role;
/*query to assign ranks to each employee based on their experience. Take data from the employee record table.*/
Select emp_id,first_name,last_name,dept,exp,RANK() over(order by EXP DESC) as EMP_EXP_RANK
from emp_record_table;
/*query to create a view that displays employees in various countries whose salary is more than six thousand. 
Take data from the employee record table.*/
CREATE VIEW EMP_SALARY AS
SELECT EMP_ID,FIRST_NAME,LAST_NAME,DEPT,SALARY,COUNTRY 
from emp_record_table
where salary > 6000 order by salary DESC;
SELECT *
from emp_salary;
/*nested query to find employees with experience of more than ten years. 
Take data from the employee record table.*/
SELECT emp_id,first_name,last_name,exp,dept,country
from emp_record_table
where exp in ( Select exp from emp_record_table where exp>10)
order by exp desc;
/* query to create a stored procedure to retrieve the details of the employees whose experience is more than three years. 
Take data from the employee record table.*/
DELIMITER &&
CREATE PROCEDURE exp_more_3()
BEGIN
 Select *
 from emp_record_table
 where exp>3
 order by exp desc;
END&&
call exp_more_3();
/* query using stored functions in the project table to check whether the job profile assigned to each employee in the data science team matches the organization’s set standard.*/
DELIMITER &&
CREATE PROCEDURE job_profile_match(IN eid varchar(50), role varchar(50), exp  int, out designation varchar(100))
BEGIN
DECLARE expr int default 1;
select exp into expr
from data_science_team
where emp_id=eid;
 IF expr <=2 THEN 
 set designation ="JUNIOR DATA SCIENTIST";
 ELSEIF expr > 5 and expr <=10 THEN
  set designation ="SENIOR DATA SCIENTIST";
 ELSEIF expr >10 and expr <=12 THEN
  set designation ="LEAD DATA SCIENTIST";
 ELSEIF expr >12 and expr <=16 THEN
  set designation ="MANAGER";
ELSE set designation ="not valid";
END IF;
END&&
Delimiter ;
call job_profile_match("E640","junior data scientist",1,@designation);
SELECT @designation;
/*Create an index to improve the cost and performance of the query to find the employee whose FIRST_NAME is ‘Eric’ in the employee table after checking the execution plan.*/
SELECT emp_id,first_name,last_name,dept
from emp_record_table
where first_name="ERIC";
Explain SELECT emp_id,first_name,last_name,dept
from emp_record_table
where first_name="ERIC";
Create index idx_firstname on emp_record_table(first_name (200));
/*a query to calculate the bonus for all the employees, based on their ratings and salaries (Use the formula: 5% of salary * employee rating)*/
SELECT emp_id,first_name,last_name,emp_rating,salary,0.05*salary*emp_rating as bonus
from emp_record_table;
/* query to calculate the average salary distribution based on the continent and country. Take data from the employee record table.*/
SELECT COUNTRY,CONTINENT, AVG(SALARY) 
FROM emp_record_table GROUP
BY COUNTRY,CONTINENT;

