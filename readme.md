---HR Payroll SQL Analysis---

A complete HR and Payroll database analysis built with MySQL,
covering salary insights, bonus distribution, deductions,
overtime, tax records and advanced SQL techniques.

---About---

This project demonstrates real world HR data analysis using
a relational database with 7 interconnected tables and over
30 analytical queries covering everything from basic exploration
to advanced SQL concepts.

---Database Schema---


Hr_Payroll Database
 employees       core table personal and job info
 departments     department reference table
 deductions      tax, insurance and other deductions
 bonuses         performance and annual bonuses
 over_time       overtime hours and rates
 pay_roll        gross and net pay per period
 tax_records     annual tax obligations


---Analysis Performed---

---Basic Exploration---
- Total employee and department count
- Gender distribution
- Contract type breakdown
- Employees per department

---Salary Analysis---
- Average salary by department, gender, job title
- Top 5 highest paid employees
- Salary band distribution
- Gender pay gap analysis

---Payroll Analysis---
- Gross vs net pay by period
- Average pay by department
- Top earners by total gross pay

---Bonus Analysis---
- Total bonuses by type
- Top 5 bonus earners
- Average bonus by department
- Employees with no bonus

---Deductions Analysis---
- Total deductions by type
- Average deduction by department
- Highest deducted employees

---Overtime Analysis---
- Overtime hours by department
- Top 5 overtime workers
- Employees with no overtime

---Tax Analysis---
- Total tax collected by year
- Effective tax rate per employee
- Tax burden by department

---Advanced Analysis---
- Full employee payroll summary 
- Department total cost analysis
- Hiring trends by year
- Longest serving employees

---Advanced SQL Concepts---

Concept                    Use Case 

 CTE->                Find employees earning above their department average 
 Subquery->           Find employees with above average bonus
 Window Function->    Rank employees by salary within department 
 Window Frame->       Running total of gross pay over time 

---Views Created---

- employee summary —> combines employee and department data
- payroll summary —> quick payroll reporting view

---How to Run---

1. Open MySQL Workbench or any MySQL client
2. Run the full script: hr_payroll_github_project.sql
3. Data will be created and all queries will execute

---Technologies Used---

- MySQL
- SQL Joins (INNER, LEFT)
- Aggregations (SUM, AVG, COUNT, MIN, MAX)
- CASE statements
- CTEs (WITH clause)
- Subqueries
- Window Functions (RANK, SUM OVER)
- Window Frames (ROWS BETWEEN)
- Views
- Foreign Key Constraints

---Author---

Haris