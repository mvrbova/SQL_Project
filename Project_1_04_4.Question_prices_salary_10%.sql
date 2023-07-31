-- 4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

-- tabulka pro potraviny
WITH basic_prices_table AS (SELECT DISTINCT 
			product_year,
			product_name,
			price_average
		FROM t_marie_vrbova_project_sql_primary_final tmvpspf)
SELECT 
	*,
	price_average - LAG(price_average) OVER (PARTITION BY product_name ORDER BY product_name, product_year ASC) AS price_average_growth,
	ROUND((price_average - LAG(price_average) OVER (PARTITION BY product_name ORDER BY product_name, product_year ASC))/LAG (price_average) OVER (PARTITION BY product_name ORDER BY product_name, product_year ASC)*100, 2) AS price_average_percentage_growth
	FROM basic_prices_table
ORDER BY price_average_percentage_growth DESC;


-- tabulka pro mzdy
WITH basic_salary_table AS (SELECT DISTINCT 
			payroll_year,
			industry_branch_name,
			salary_average
		FROM t_marie_vrbova_project_sql_primary_final tmvpspf 
		WHERE industry_branch_name IS NOT NULL)
SELECT 
	*
	salary_average - LAG(salary_average) OVER (PARTITION BY industry_branch_name ORDER BY industry_branch_name, payroll_year ASC) AS average_salary_growth,
	ROUND((salary_average - LAG(salary_average) OVER (PARTITION BY industry_branch_name ORDER BY industry_branch_name, payroll_year ASC))/LAG (salary_average) OVER (PARTITION BY industry_branch_name ORDER BY industry_branch_name, payroll_year ASC)*100, 2) AS average_salary_percentage_growth
	FROM basic_salary_table
ORDER BY average_salary_percentage_growth DESC;


-- propojení tabulek pro ceny a pro mzdy; vytvoření průměru nárůstu cen všech kategorií ročně a jeho porovnání s nárůstem platů
WITH basic_salary_table AS (SELECT DISTINCT 
			payroll_year,
			industry_branch_name,
			salary_average,
			salary_average - LAG(salary_average) OVER (PARTITION BY industry_branch_name ORDER BY industry_branch_name, payroll_year ASC) AS salary_average_growth,
			ROUND((salary_average - LAG(salary_average) OVER (PARTITION BY industry_branch_name ORDER BY industry_branch_name, payroll_year ASC))/LAG (salary_average) OVER (PARTITION BY industry_branch_name ORDER BY industry_branch_name, payroll_year ASC)*100, 2) AS salary_average_percentage_growth
			FROM t_marie_vrbova_project_sql_primary_final tmvpspf 
			WHERE industry_branch_name IS NOT NULL),
basic_prices_table AS (SELECT DISTINCT 
			product_year,
			product_name,
			price_average,
			price_average - LAG(price_average) OVER (PARTITION BY product_name ORDER BY product_name, product_year ASC) AS price_average_growth,
			ROUND((price_average - LAG(price_average) OVER (PARTITION BY product_name ORDER BY product_name, product_year ASC))/LAG (price_average) OVER (PARTITION BY product_name ORDER BY product_name, product_year ASC)*100, 2) AS price_average_percentage_growth
			FROM t_marie_vrbova_project_sql_primary_final tmvpspf)
SELECT DISTINCT
	product_year,
	product_name,
	price_average_percentage_growth,
	industry_branch_name,
	salary_average_percentage_growth,
	ROUND(AVG (price_average_percentage_growth), 2) AS price_yearly_average
FROM basic_salary_table, basic_prices_table
WHERE basic_salary_table.payroll_year = basic_prices_table.product_year
	AND price_average_percentage_growth > 10
GROUP BY product_year
ORDER BY price_yearly_average DESC;


-- propojení tabulek pro ceny a pro mzdy; porovnání nárůstu cen jednotlivých potravin s nárůstem platů
WITH basic_salary_table AS (SELECT DISTINCT 
			payroll_year,
			industry_branch_name,
			salary_average,
			salary_average - LAG(salary_average) OVER (PARTITION BY industry_branch_name ORDER BY industry_branch_name, payroll_year ASC) AS salary_average_growth,
			ROUND((salary_average - LAG(salary_average) OVER (PARTITION BY industry_branch_name ORDER BY industry_branch_name, payroll_year ASC))/LAG (salary_average) OVER (PARTITION BY industry_branch_name ORDER BY industry_branch_name, payroll_year ASC)*100, 2) AS salary_average_percentage_growth
			FROM t_marie_vrbova_project_sql_primary_final tmvpspf 
			WHERE industry_branch_name IS NOT NULL),
basic_prices_table AS (SELECT DISTINCT 
			product_year,
			product_name,
			price_average,
			price_average - LAG(price_average) OVER (PARTITION BY product_name ORDER BY product_name, product_year ASC) AS price_average_growth,
			ROUND((price_average - LAG(price_average) OVER (PARTITION BY product_name ORDER BY product_name, product_year ASC))/LAG (price_average) OVER (PARTITION BY product_name ORDER BY product_name, product_year ASC)*100, 2) AS price_average_percentage_growth
			FROM t_marie_vrbova_project_sql_primary_final tmvpspf)
SELECT DISTINCT
	product_year,
	product_name,
	price_average_percentage_growth,
	industry_branch_name,
	salary_average_percentage_growth,
	(price_average_percentage_growth - salary_average_percentage_growth) AS pr_sal_perc_growth
FROM basic_salary_table, basic_prices_table
WHERE basic_salary_table.payroll_year = basic_prices_table.product_year
	AND (price_average_percentage_growth - salary_average_percentage_growth) > 10
GROUP BY product_year
ORDER BY pr_sal_perc_growth DESC;
