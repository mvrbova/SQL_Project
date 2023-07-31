-- 2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

-- vybrání dat pro mléko
SELECT 
	product_year,
	product_name,
	industry_branch_name,
	price_average,
	salary_average,
	CASE
		WHEN (product_name = 'Mléko polotučné pasterovane') THEN ROUND (salary_average/price_average)
	END AS l_of_milch_per_year
	FROM t_marie_vrbova_project_sql_primary_final tmvpspf 
	WHERE product_name = 'Mléko polotučné pasterovane' AND industry_branch_name IS NOT NULL AND product_year IN (2006,2018) 
	ORDER BY product_year, l_of_milch_per_year;


-- vybrání dat pro chléb
SELECT 
	product_year,
	product_name,
	industry_branch_name,
	price_average,
	salary_average,
	CASE
		WHEN (product_name = 'Chléb konzumní kmínový') THEN ROUND (salary_average/price_average)
	END AS kg_of_bread_per_year
	FROM t_marie_vrbova_project_sql_primary_final tmvpspf 
	WHERE product_name = 'Chléb konzumní kmínový' AND industry_branch_name IS NOT NULL AND product_year IN (2006,2018)
	ORDER BY product_year, kg_of_bread_per_year;

