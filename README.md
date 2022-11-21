# Pewlett-Hackard-Analysis

## Overview

As many are reaching the retirement age, the employees at Pewlett-Hackard need to be prepared for the upcoming “silver tsunami”. The company is looking toward the future by offering a retirement package for those who meet certain criteria, and thinking about which positions will need to be filled in the near future. 

Using Structured Query Language (SQL), we will be able to build an employee database to help meet the objectives at Pewlett-Hackard. In order to ensure a smooth transition, this analysis focuses on the following:

* Identify how many retiring employees by their title.
* Identify the employees eligible for participation in the mentorship program.
* Determine the number of roles that need to be filled.
* Determine the number of qualified, retirement-ready employees to mentor the next generation.

## Resources

### Data Source:

[Pewlett-Hackard Employee Data (CSV)](https://github.com/doliver231/Pewlett-Hackard-Analysis/tree/main/Data)

### Software:

* PostgreSQL
* pgAdmin 4
* Quick Database Diagrams (Quick DBD)

## Results: 

Using an Entity Relationship Diagram (ERD) by Quick DBD, we were able to map out the relationships among all the csv files to be analyzed. The primary, foreign, and unique keys were also identified in order to continue building a database using PostgreSQL.

![ERD for our Employee Database](https://github.com/doliver231/Pewlett-Hackard-Analysis/blob/main/EmployeeDB.png)

A Retirement Titles table was created to hold all the titles of employees who were born between January 1, 1952 and December 31, 1955. Because some employees may have multiple titles in the database, possibly due to promotions, the `DISTINCT ON`sql statement was used to create a table that contains the most recent title of each employee. Then, by using the `COUNT()`sql function, a table was created that held the number of retirement-age employees by most recent job title. Finally, because we want to include only current employees in our analysis, those employees who have already left the company were excluded.

### 1. Retiring Employee by Title

The table includes employee number, first name, last name, title, from-date and to-date. It was created by joining two different tables together on the same primary key, employee number. The query returned 133,776 rows. Some employees appear more than once due to change of title during their career at Pewlett-Hackard.

```sql
SELECT e.emp_no, 
    e.first_name, 
    e.last_name, 
    t.title, 
    t.from_date, 
    t.to_date
INTO retirement_titles
FROM employees as e
INNER JOIN titles as t
ON e.emp_no = t.emp_no
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY emp_no;
```

![Retiring Employees by Title Output](https://github.com/doliver231/Pewlett-Hackard-Analysis/blob/main/Screenshots/Deliverable1_retirement_titles.png)


2. The list of retiring employees without duplicates

The table includes employee number, first name, last name, title, from-date and to-date.
The query returns 90,398 rows.
The table displays a list of employees who are going to retire in the next few years.
In the table each employee is listed only once, by her or his most recent title.


Figure 3: Table with the employee’s data that are retirement-ready without duplicates

Overview of the code

Query contains the same data as the query above with addition of distinct_on command that kept only unique values. To ensure that most recent values are kept, I used command ORDER BY rt.emp_no, rt.to_date DESC to sort the data by descending order on the to_date column. In this case the most recent title was listed first, and after running the query the duplicates listed after the first appearance of the same employees were removed.

3. The number of retiring employees grouped by title

The table includes employees’ titles and their sum.
The query returns a cohesive table with 7 rows.
From this table we can quickly see how many employees with certain title will retire in the next few years.


Figure 4: Table with the employee grouped by title

Overview of the code

In order to retrieve this table I used GROUP BY ut.title command, and it is responsible for grouping the rows by titles. Next, I used its corresponding command COUNT (ut.title) that counts how many times specific title appears in the database.

4. The employees eligible for the mentorship program

The table contains employee number, first name, last name, birth date, from date, to date and title.
The query returns 1,549 rows.
The table displays a list of employees who is eligible for the mentorship program.


Figure 5: Table with the employee grouped by title

Overview of the code

To retrieve this data, three tables were merge together: employees, titles and dep_emp with the inner join. The query filters by birth date (that indicates who is eligible for the mentorship program) with the command WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31') and to_date to include only current employees. Duplicates were removed by DISTINCT ON (e.emp_no) command. To ensure I got the most recent titles, I used ORDER BY e.emp_no, ti.from_date DESC command.



## Summary:

-Provide high-level responses to the following questions, then provide two additional queries or tables that may provide more insight into the upcoming "silver tsunami."

-How many roles will need to be filled as the "silver tsunami" begins to make an impact?

-Are there enough qualified, retirement-ready employees in the departments to mentor the next generation of Pewlett Hackard employees?