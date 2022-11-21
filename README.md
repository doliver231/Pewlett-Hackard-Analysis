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

A Retirement Titles table was created to hold all the titles of employees who were born between January 1, 1952 and December 31, 1955. Because some employees may have multiple titles in the database, possibly due to promotions, the `DISTINCT ON` statement was used to create a table that contains the most recent title of each employee. Then, by using the `COUNT()` function, a table was created that held the number of retirement-age employees by most recent job title. Finally, because we want to include only current employees in our analysis, those employees who have already left the company were excluded.

### 1. Retiring Employees by Title

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


### 2. Retiring Employees by Title (without duplicates)

In the table each employee is listed only once, by her or his most recent title, using `DISTINCT ON` in our query code. We also excluded those employees that have already left the company by filtering on "to_date" to keep only those dates that are equal to "9999-01-01". This time, the query returned 72,458 rows.

```sql
SELECT DISTINCT ON (emp_no) emp_no,
    first_name,
    last_name,
    title
INTO unique_titles
FROM retirement_titles as rt
WHERE rt.to_date = ('9999-01-01')
ORDER BY emp_no, to_date DESC;
```

![Retiring Employees by Title Output w/o Dups](https://github.com/doliver231/Pewlett-Hackard-Analysis/blob/main/Screenshots/Deliverable1_unique_titles.png)

### 3. Retiring Employees Grouped by Title

This table was created to retrieve the number of employees by their most recent job title who are about to retire. Using `GROUP BY` and `COUNT()`, we were able to return a cohesive table with 7 rows showing the number of job retiring employees grouped by each specific title category. `ORDER BY` statement was also added to order the counts for each group in a descending manner (`DESC`).

```sql
SELECT COUNT(title) as count, title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY count DESC;
```

![Retiring Employees by Title Output Group by](https://github.com/doliver231/Pewlett-Hackard-Analysis/blob/main/Screenshots/Deliverable1_retiring_titles.png)

### 4. Employees Eligible for the Mentorship Program

The table contains employee number, first name, last name, birth date, from date, to date and title. It was created to hold all the current employees who were born between January 1, 1965 and December 31, 1965, and thus are eligible for the mentorship program. Three tables were joined using `INNER JOIN` and specific filters on "birth_date" and "to_date" were applied. The query returned with 1,549 rows.

```sql
SELECT DISTINCT ON (e.emp_no) e.emp_no,
    e.first_name, 
    e.last_name, 
    e.birth_date,
    de.from_date,
    de.to_date,
    t.title
INTO mentorship_elegibility
FROM employees as e
INNER JOIN dept_employees as de ON e.emp_no = de.emp_no
INNER JOIN titles as t ON e.emp_no = t.emp_no
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
	 AND (de.to_date = '9999-01-01')
ORDER BY emp_no;
```
![Mentorship Eligibility](https://github.com/doliver231/Pewlett-Hackard-Analysis/blob/main/Screenshots/Deliverable2_mentorship_elegibility.png)

## Summary:

As the company is preparing for the upcoming "silver tsunami" a good preparation and planning is important, especially when such a large number of the employees is involved. The analysis above give pretty good insight about the number of the employees that are about to retire and their respective titles. However, additional queries can be performed that will provide even more useful information for the company. If we joined another table with "departments" column, we will be able to see specifically which roles need to be filled per department. After removing the duplicates, with `DISTINCT ON` command, the table was ready to be used for additional queries. The first five rows out of 72,458 are shown:

```sql
SELECT DISTINCT ON (rt.emp_no) 
	rt.emp_no,
	rt.first_name,
	rt.last_name,
	rt.title,
	d.dept_name
INTO retirement_titles_dept
FROM retirement_titles as rt
INNER JOIN dept_employees as de
ON (rt.emp_no = de.emp_no)
INNER JOIN departments as d
ON (d.dept_no = de.dept_no)
WHERE rt.to_date = ('9999-01-01')
ORDER BY rt.emp_no, rt.to_date DESC;
```

![by department](https://github.com/doliver231/Pewlett-Hackard-Analysis/blob/main/Screenshots/Deliverable3_departments.png)

* How many roles will need to be filled as the "silver tsunami" begins to make an impact?

To get the number of positions that will be open after the "silver tsunami" hits, an additional query was created that breaks down how many staff will retire per department. Since every department will be affected in some way, this query gives more precise numbers what each department can expect and how many roles will need to be filled. This query yields 38 rows.

```sql
SELECT COUNT(rtd.title) as count_titles,  
	rtd.dept_name, 
	rtd.title
INTO rolls_to_fill
FROM retirement_titles_dept as rtd
GROUP BY rtd.dept_name, rtd.title
ORDER BY count_titles DESC;
```

![rolls to fill](https://github.com/doliver231/Pewlett-Hackard-Analysis/blob/main/Screenshots/Deliverable3_rolls_to_fill.png)

* Are there enough qualified, retirement-ready employees in the departments to mentor the next generation of Pewlett Hackard employees?

An additional query was created that filters those employees on higher positions, assuming that those are qualified as mentors. The positions that seem to fall under the qualified category are Senior Engineer, Senior Staff, Technique Leader, and Manager. From the table we can see how many qualified employees are in each department to train the next generation.

```sql
SELECT  COUNT(rtd.title) as count_titles,
	rtd.dept_name, 
	rtd.title
INTO qualified_staff
FROM retirement_titles_dept as rtd
WHERE rtd.title IN ('Senior Engineer', 'Manager', 'Senior Staff', 'Technique Leader')
GROUP BY rtd.dept_name, rtd.title
ORDER BY count_titles DESC;
```

![qualified staff](https://github.com/doliver231/Pewlett-Hackard-Analysis/blob/main/Screenshots/Deliverable3_qualified_mentors.png)