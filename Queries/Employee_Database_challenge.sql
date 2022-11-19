-- DELIVERABLE 1: Query for Retirement Titles
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

-- DELIVERABLE 1: Query for Unique Titles
SELECT DISTINCT ON (emp_no) emp_no,
    first_name,
    last_name,
    title
INTO unique_titles
FROM retirement_titles as rt
WHERE rt.to_date = ('9999-01-01')
ORDER BY emp_no, to_date DESC;

-- DELIVERABLE 1: Query for Retiring Titles
SELECT COUNT(title) as count, title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY count DESC;

-- DELIVERABLE 2: Query for Mentorship Eligibility
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

-- DELIVERABLE 3: Query for Retirement Titles + Departments
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
ORDER BY rt.emp_no, rt.to_date DESC;

-- DELIVERABLE 3: Query to find how many roles will need to be filled
SELECT COUNT(rtd.title) as count_titles,  
	rtd.dept_name, 
	rtd.title
INTO rolls_to_fill
FROM retirement_titles_dept as rtd
GROUP BY rtd.dept_name, rtd.title
ORDER BY rtd.dept_name DESC;

-- DELIVERABLE 3: Query to find how many employees are qualified to mentor next generation
SELECT  COUNT(rtd.title) as count_titles,
	rtd.dept_name, 
	rtd.title
INTO qualified_staff
FROM retirement_titles_dept as rtd
WHERE rtd.title IN ('Senior Engineer', 'Manager', 'Senior Staff', 'Technique Leader')
GROUP BY rtd.dept_name, rtd.title
ORDER BY rtd.dept_name DESC;