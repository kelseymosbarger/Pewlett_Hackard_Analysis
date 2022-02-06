-- Retiring EEs by title - joining employee and title table
SELECT e.emp_no,
	   e.first_name,
	   e.last_name,
	   ti.title,
	   ti.from_date,
	   ti.to_date
	INTO retirement_titles
	FROM employees AS e
	INNER JOIN titles AS ti
	on e.emp_no = ti.emp_no
	WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
	ORDER BY emp_no;

SELECT * FROM retirement_titles;

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (rt.emp_no) rt.emp_no,
				   rt.first_name,
				   rt.last_name,
				   rt.title
	INTO unique_titles
	FROM retirement_titles AS rt
	WHERE (rt.to_date = '9999-01-01')
	ORDER BY emp_no, to_date DESC;
	
SELECT * FROM unique_titles;

-- Use Unique count to group by and sum by titles
SELECT COUNT (ut.title), ut.Title
	INTO retiring_titles
	FROM unique_titles AS ut
	GROUP BY ut.title
	ORDER BY COUNT DESC;

SELECT * FROM retiring_titles


-- Employees Eligable for the mentorship program
SELECT DISTINCT ON (e.emp_no) e.emp_no,
				    e.first_name,
					e.last_name,
					e.birth_date,
					de.from_date,
					de.to_date,
					ti.title
	INTO mentorship_eligibility
	FROM employees AS e
	LEFT JOIN dept_emp AS de
	ON (e.emp_no = de.emp_no)
	LEFT JOIN titles AS ti
	ON (e.emp_no = ti.emp_no)
	WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
		AND (de.to_date = '9999-01-01')
	ORDER BY e.emp_no
	
SELECT * FROM mentorship_eligibility


-- Use Dictinct with Orderby to remove duplicate rows - adding in departments
SELECT DISTINCT ON (rt.emp_no) rt.emp_no,
				   rt.first_name,
				   rt.last_name,
				   rt.title,
				   de.dept_no,
				   d.dept_name
	INTO retirement_dept
	FROM retirement_titles AS rt
	LEFT JOIN dept_emp AS de
	ON (rt.emp_no = de.emp_no)
	LEFT JOIN departments AS d
	ON (d.dept_no = de.dept_no)
	WHERE (rt.to_date = '9999-01-01')
	ORDER BY emp_no, dept_name DESC;
	
SELECT * FROM retirement_dept;


SELECT COUNT (rd.dept_name), rd.dept_name
	INTO retiring_dept_summary
	FROM retirement_dept AS rd
	GROUP BY rd.dept_name
	ORDER BY COUNT DESC;

SELECT * FROM retiring_dept_summary

-- unique total employees
SELECT DISTINCT ON (e.emp_no) e.emp_no,
				    e.first_name,
					e.last_name,
					e.birth_date,
					de.from_date,
					de.to_date,
					ti.title
	INTO unique_ee_total
	FROM employees AS e
	LEFT JOIN dept_emp AS de
	ON (e.emp_no = de.emp_no)
	LEFT JOIN titles AS ti
	ON (e.emp_no = ti.emp_no)
	WHERE (de.to_date = '9999-01-01')
	ORDER BY e.emp_no


SELECT COUNT(emp_no) FROM mentorship_eligibility