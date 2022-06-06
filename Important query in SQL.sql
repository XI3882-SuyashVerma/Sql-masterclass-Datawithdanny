----------------------------------GATE SMASHERS--------------------------

--Query 1 -- Maximum Value from Salary in EMP Table


--****very Important

--Use of nested query to solve this - max salary employee name

SELECT e_name,e_id
FROM employee
WHERE salary = (SELECT max(salary) from employee)

--2nd highest salary

select max(salary)
FROM employee
WHERE Salary <> (SELECT max(salary) from employee)

--Name of employee with 2nd highest salary

SELECT e_name
FROM employee
WHERE salary = 
(
select max(salary) 
from employee 
where salary <> (select max(salary) from employee )
)

--Display dept whose employee is less than 2  -- Output is IT
--Why we can't use where clause is that it works on whole date and not on any part of date created by group by

select dept
FROM employee
GROUP BY dept
HAVING count(*) < 2

--Now display the name of employee whose dept has less than 2 employee

SELECT e_name
FROM employee
where dept IN
(
    select dept
    from employee
    GROUP by dept
    HAVING COUNT(*) < 2 -- Because where applies for 
)

--Query for highest salary department wise with name

SELECT e-name
FROM employee
WHERE salary In (
    SELECT MAX(salary)
    FROM emloyee
    GROUP BY dept
)

--Solving problem by Nested subquery -- Co-related subquery -- Joins

--Detail of employee who works in any Dept.

--Using Nested Subquery going bottom-up Approach

SELECT *
FROM employee
where eid IN
(
    SELECT eid 
FROM dept
)

--Solving it by now Co-related query

SELECT *
FROM employee
where EXISTS 
(
SELECT eid
FROM dept
where dept.eid = employee.eid
)


--Solving it by Joins

SELECT attributes
FROM employees
where dept.eid = employee.eid

--Nth highest salary Very Imp --5th salary 

SELECT *
FROM employee e1
where 5 = 
(
    SELECT count(distinct(salary))
    FROM employee e2
    where e2.salary > e1.salary
)

--Using CTE solving question of Highest getting marks
WITH Max_Mark AS
(
SELECT (m1+m2+m3) as sum,
    DENSE_RANK() OVER (ORDER BY sum Desc) AS Rnk
FROM Student
)
SELECT Name
FROM MAx_Mark
WHERE Rnk=1;












