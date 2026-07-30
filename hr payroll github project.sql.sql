-- HR Payroll Database Analysis
-- Complete HR and Payroll analysis
-- using MySQL covering salary, bonus,
-- deductions, overtime, tax analysis
-- and advanced SQL concepts.


--  create and select the database
create database Hr_Payroll;

use Hr_Payroll;

-- create all tables with appropriate data types and constraints.

create table employees(employee_id int primary key,
first_name varchar(25),
last_name  varchar(30),
gender varchar(10),
dob date,
hire_date date,
department_id int,
job_title  varchar(30),
base_salary decimal(10,2),
contract_type varchar(30)
);



create table departments(department_id int primary key,
department_name varchar(30));
                        
                        
create table deductions(deduction_id int primary key,
employee_id int,
deduction_type varchar(30),
amount decimal(10,2));

create table bonuses(bonus_id int primary key,
employee_id int,
bonus_type varchar(30),
amount decimal(15,2));

create table over_time(overtime_id int primary key,
employee_id int,
hours decimal(10,2),
rate decimal(10,2));

create table pay_roll(payroll_id int primary key,
employee_id int,
gross_pay decimal(15,2),
net_pay decimal(15,2),
pay_period date);

create table tax_records(tax_id int primary key,
employee_id int,
tax_year year,
taxable_income decimal(10,2),
tax_amount decimal(10,2));


 
--  Foreign Key Constraints 
-- enforce referential integrity across all tables
alter table employees
add constraint fk_departments
foreign key (department_id)
references departments(department_id);

alter table deductions
add constraint fk_employees
foreign key (employee_id)
references employees(employee_id);

alter table bonuses
add constraint fk_bonuses_employees
foreign key (employee_id)
references employees(employee_id);

alter table over_time
add constraint fk_over_time_employees
foreign key (employee_id)
references employees(employee_id);

alter table pay_roll
add constraint fk_pay_roll_employees
foreign key (employee_id)
references employees(employee_id);

alter table tax_records
add constraint fk_tax_records_employees
foreign key (employee_id)
references employees(employee_id);




--  Data Import
--  data was imported using MySQL Workbench
-- Table Data Import Wizard (CSV import)



-- Basic Exploration

-- show all tables in the database
show tables;

-- preview all tables
select * from employees,departments,deductions,bonuses,pay_roll,over_time,tax_records;

-- how many employees do we have?
select count(*) as total_employees from employees;


-- how many departments?
select count(department_id) as total_departments from departments;


-- gender distribution
select gender,count(*) as gender_count from employees
group by gender;

-- contract type distribution
select contract_type,count(*) as contract from employees
group by contract_type
;

-- employees by department
select d.department_name,count(e.employee_id) as emp_by_dept from employees e
join 
departments d on d.department_id=e.department_id
group by d.department_name;

-- Salary Analysis

-- average salary by department
select d.department_name,round(avg(e.base_salary),2) as avg_sal_by_dept from employees e
join 
departments d on e.department_id=d.department_id
group by department_name
;

-- average salary by gender

select gender,round(avg(base_salary)) as avg_sal_by_gender from employees
group by gender
;

-- average salary by job title
select job_title,round(avg(base_salary),2) as avg_sal_by_job,COUNT(*) AS total_employees from employees
group by job_title
order by avg_sal_by_job desc
;
-- average salary by contract type

select contract_type,round(avg(base_salary)) as avg_sal_by_contract from employees
group by contract_type
;

-- top 5 highest paid employees
select first_name,last_name,base_salary as max_sal from employees
order by base_salary desc
limit 5;

-- salary ranges
select case 
         when base_salary between "1000" and "3000" then "1k-3k"
         when base_salary between "3000" and "6000" then "3k-6k"
         when base_salary between "6000" and "9000" then "6k-9k"
         else "above 9k" end as salary_range, count(*) as total_employee
         from employees
group by salary_range
order by total_employee desc
;

-- Payroll Analysis

-- total gross and net pay by period

select pay_period,sum(gross_pay) as gross_by_period,
sum(net_pay) as net_by_period,
round(sum(gross_pay)-sum(net_pay),2) as difference 
from pay_roll
group by pay_period
order by pay_period
;
-- average gross vs net pay by department
select d.department_name,
round(avg(p.gross_pay),2) as gross_by_dept,
round(avg(p.net_pay),2) as net_by_dept from pay_roll p 
join
employees e on e.employee_id=p.employee_id
join departments d on d.department_id=e.department_id
group by d.department_name 
;

-- employees with highest total gross pay

select e.first_name,e.last_name,round(sum(p.gross_pay),2) as avg_gross_pay from employees e
join 
pay_roll p on p.employee_id=e.employee_id
group by e.first_name,e.last_name
order by avg_gross_pay desc 
limit 5
;

-- Bonus Analysis

-- total bonuses paid by type
select bonus_type,sum(amount) as total_amount,count(*) AS TIMES_AWARDED from bonuses
group by bonus_type
order by total_amount desc
;
-- top 5 employees by total bonus received
select e.first_name,e.last_name,sum(b.amount) as total_amount from employees e
join
bonuses b on e.employee_id=b.employee_id
group by e.first_name,e.last_name
order by total_amount desc
limit 5;

-- average bonus by department
select d.department_name,round(avg(b.amount),2) as avg_bonus from employees e
join 
departments d on d.department_id=e.department_id
join bonuses b on e.employee_id=b.employee_id
group by d.department_name
order by avg_bonus desc
;
-- employees who received no bonus
select e.first_name,e.last_name from employees e
left join 
bonuses b on b.employee_id=e.employee_id
where b.bonus_id is null or b.amount=0
;
-- Deductions Analysis
-- total deductions by type
select deduction_type,sum(amount) as deduction_amount,count(*) as times_applied from deductions 
group by deduction_type
order by deduction_amount desc
;
-- average deduction per employee by department
select e.first_name,e.last_name,dep.department_name,round(avg(ded.amount),2) as avg_ded_amount  from employees e
join
departments dep on dep.department_id=e.department_id
join deductions ded on ded.employee_id=e.employee_id
group by e.first_name,e.last_name,dep.department_name
order by avg_ded_amount desc
;

-- employees with highest total deductions
select e.first_name,e.last_name,sum(d.amount) as total_deduction from employees e
join
deductions d on e.employee_id=d.employee_id
group by e.first_name,e.last_name
order by total_deduction desc
limit 5
;
-- Overtime Analysis
-- total overtime hours by department
SELECT d.department_name,
       ROUND(SUM(o.hours), 2) AS total_overtime_hours,
       ROUND(AVG(o.rate), 2) AS avg_overtime_rate
FROM over_time o
JOIN employees e ON o.employee_id = e.employee_id
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY total_overtime_hours DESC;

-- top 5 employees by overtime hours
SELECT e.first_name, e.last_name,
       ROUND(SUM(o.hours), 2) AS total_hours,
       ROUND(SUM(o.hours * o.rate), 2) AS total_overtime_pay
FROM over_time o
JOIN employees e ON o.employee_id = e.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name
ORDER BY total_hours DESC
LIMIT 5;

-- employees with no overtime
SELECT e.first_name, e.last_name, e.job_title
FROM employees e
LEFT JOIN over_time o ON e.employee_id = o.employee_id
WHERE o.overtime_id IS NULL;

-- Tax Analysis

-- total tax collected by year
select tax_year,sum(taxable_income) as total_taxable_income,sum(tax_amount) as tot_tax_amount from tax_records
group by tax_year
order by tot_tax_amount desc

-- average tax rate per employee
SELECT e.first_name, e.last_name,
       ROUND(AVG(t.tax_amount / t.taxable_income * 100), 2) AS avg_tax_rate
FROM tax_records t
JOIN employees e ON t.employee_id = e.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name
ORDER BY avg_tax_rate DESC
LIMIT 5;

-- tax by department
SELECT d.department_name,
       ROUND(SUM(t.tax_amount), 2) AS total_tax
FROM tax_records t
JOIN employees e ON t.employee_id = e.employee_id
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY total_tax DESC;


-- full employee payroll summary
select e.first_name,e.last_name,e.employee_id,e.job_title,dep.department_name,e.base_salary,sum(b.amount) as tot_bonus,
sum(ded.amount) as tot_deductions,sum(o.rate*o.hours) as tot_overtime_pay,sum(p.net_pay) as tot_net_pay from employees e
join 
departments dep on dep.department_id=e.department_id
left join bonuses b on e.employee_id=b.employee_id
left join deductions ded on e.employee_id=ded.employee_id
left join over_time o on o.employee_id=e.employee_id
left join pay_roll p on p.employee_id=e.employee_id
group by e.first_name,e.last_name,e.job_title,dep.department_name,e.base_salary,e.employee_id
order by tot_net_pay desc;

-- gender pay gap analysis
SELECT gender,
       ROUND(AVG(base_salary), 2) AS avg_salary,
       ROUND(MIN(base_salary), 2) AS min_salary,
       ROUND(MAX(base_salary), 2) AS max_salary,
       COUNT(*) AS total_employees
FROM employees
GROUP BY gender;

-- department cost analysis 

select d.department_name,sum(e.base_salary) as total_base_salary,
sum(b.amount) as total_bonuses,
round(sum(o.hours*o.rate),2) as total_overtime,
round(sum(e.base_salary)+coalesce(sum(b.amount),0)+coalesce(sum(o.hours*o.rate),0),2) as total_department_cost
from employees e
join
departments d on d.department_id=e.department_id
join bonuses b on e.employee_id=b.employee_id
join over_time o on o.employee_id=e.employee_id
group by d.department_name
order by total_department_cost desc;

-- employees hired per year
SELECT YEAR(hire_date) AS hire_year,
       COUNT(*) AS employees_hired
FROM employees
GROUP BY hire_year
ORDER BY hire_year;

-- longest serving employees
SELECT first_name, last_name,
       hire_date,
       TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) AS years_of_service
FROM employees
ORDER BY years_of_service DESC
LIMIT 10;

-- view for employee summary
CREATE VIEW employee_summary AS
SELECT e.employee_id,
       e.first_name, e.last_name,
       e.gender, e.job_title,
       d.department_name,
       e.base_salary,
       e.contract_type,
       TIMESTAMPDIFF(YEAR, e.hire_date, CURDATE()) AS years_of_service
FROM employees e
JOIN departments d ON e.department_id = d.department_id;

SELECT * FROM employee_summary
ORDER BY years_of_service DESC;

-- view for payroll summary
CREATE VIEW payroll_summary AS
SELECT e.first_name, e.last_name,
       d.department_name,
       p.gross_pay, p.net_pay,
       p.pay_period
FROM pay_roll p
JOIN employees e ON p.employee_id = e.employee_id
JOIN departments d ON e.department_id = d.department_id;

-- Question: Using a CTE, find all employees whose base salary is above the average salary of their department. 
-- Show their name, job title, department, their salary and the department average salary.

with emp as(select d.department_name,round(avg(e.base_salary),2) as avg_sal_by_dept from employees e
join 
departments d on d.department_id=e.department_id
group by d.department_name
),
emp1 as(select e.first_name,e.last_name,e.job_title,d.department_name,e.base_salary from employees e
join 
departments d on d.department_id=e.department_id

)
SELECT 
    emp1.*,
    emp.avg_sal_by_dept
FROM emp1
JOIN emp ON emp1.department_name = emp.department_name
WHERE emp1.base_salary > emp.avg_sal_by_dept;

-- Question: Find all employees who have received a bonus amount higher than the average bonus amount across all employees.
--  Show their first name, last name, job title and their total bonus amount.

select t.first_name,t.last_name,t.job_title,t.amount,(select round(avg(amount),2) from bonuses) as avg_bonus_amount from (select e.first_name,e.last_name,e.job_title,b.amount from employees e
join 
bonuses b on e.employee_id=b.employee_id
where b.amount>(select round(avg(amount),2) as avg_bonus_amount from bonuses)
) as t;

-- Rank all employees within each department by their base salary from highest to lowest.
--  Show their name, department, salary and their rank within the department.

select e.first_name,e.last_name,e.base_salary,d.department_name,
rank() over(partition by d.department_name order by e.base_salary desc) as dept_rank from employees e
join 
departments d on d.department_id=e.department_id
;
-- For each pay period, calculate the running total of gross pay ordered by pay period.
--  Show the pay period, gross pay for that period and the cumulative total up to that point.

select pay_period,gross_pay,
sum(gross_pay) over(order by pay_period rows between unbounded preceding and current row) as running_total
from pay_roll
order by running_total asc



                        