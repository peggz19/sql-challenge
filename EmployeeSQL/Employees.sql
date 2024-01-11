-- Dropping Tables in case I need to start over.

DROP TABLE IF EXISTS "SQL Challenge"."public"."departments" CASCADE;
DROP TABLE IF EXISTS "SQL Challenge"."public"."dept_emp" CASCADE;
DROP TABLE IF EXISTS "SQL Challenge"."public"."dept_manager" CASCADE;
DROP TABLE IF EXISTS "SQL Challenge"."public"."employees" CASCADE;
DROP TABLE IF EXISTS "SQL Challenge"."public"."salaries" CASCADE;
DROP TABLE IF EXISTS "SQL Challenge"."public"."titles" CASCADE;

-- PART 1. DATA MODELING (done with the above link)
SET datestyle ='ISO,YMD'; -- changing the csv date type was needed to ensure it matches the ymd style of Postgresql
SHOW datestyle;

CREATE TABLE "employees" (
    "emp_no" int   NOT NULL,
    "emp_title" varchar  NOT NULL,
    "birth_date" date NOT NULL,
    "first_name" varchar   NOT NULL,
    "last_name" varchar   NOT NULL,
    "sex" varchar   NOT NULL,
    "hire_date" date   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "departments" (
    "dept_no" varchar   NOT NULL,
    "dept_name" varchar   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "dept_emp" (
    "emp_no" int   NOT NULL,
    "dept_no" varchar   NOT NULL
);

CREATE TABLE "dept_manager" (
    "dept_no" varchar   NOT NULL,
    "emp_no" int   NOT NULL
);

CREATE TABLE "salaries" (
    "emp_no" int   NOT NULL,
    "salary" int   NOT NULL
);

CREATE TABLE "titles" (
    "title_id" varchar   NOT NULL,
    "title" varchar   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title" FOREIGN KEY("emp_title")
REFERENCES "titles" ("title_id");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

-- PART 2. DATA ENGINEERING (Importing csv files)
-- The importation order was Titles, Employees, Departments, the rest has no importance

-- PART 3. DATA ANALYSIS

--List the employee number, last name, first name, sex, and salary of each employee.
SELECT employees.emp_no
 	,employees.last_name
	,employees.first_name
	,employees.sex
	,salaries.salary
	FROM employees
	JOIN salaries
	ON employees.emp_no=salaries.emp_no
	
--List the first name, last name, and hire date for the employees who were hired in 1986
SELECT employees.first_name,
		employees.last_name,
		employees.hire_date
		FROM employees
		WHERE hire_date between '1986-01-01' and '1986-12-31';
		
--List the manager of each department along with their department number, department name, 
--employee number, last name, and first name

SELECT titles.title,
		employees.last_name,
		employees.first_name,
		employees.emp_no,
		departments.dept_name,
		departments.dept_no
		FROM employees
		INNER JOIN titles
		ON employees.emp_title = titles.title_id
		INNER JOIN dept_manager
		ON employees.emp_no = dept_manager.emp_no
		INNER JOIN departments
		ON departments.dept_no = dept_manager.dept_no