-- 1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

WITH basic_table AS (SELECT DISTINCT 
			payroll_year,
			industry_branch_name,
			salary_average
		FROM t_marie_vrbova_project_sql_primary_final tmvpspf 
		WHERE industry_branch_name IS NOT NULL)
SELECT 
	*,
	salary_average - LAG(salary_average) OVER (PARTITION BY industry_branch_name ORDER BY industry_branch_name, payroll_year ASC) AS salary_average_growth,
	ROUND((salary_average - LAG(salary_average) OVER (PARTITION BY industry_branch_name ORDER BY industry_branch_name, payroll_year ASC))/LAG (salary_average) OVER (PARTITION BY industry_branch_name ORDER BY industry_branch_name, payroll_year ASC)*100, 2) AS salary_average_percentage_growth
	FROM basic_table;