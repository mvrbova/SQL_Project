-- 5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?

-- zjistit, pro které roky jsou dostupná data HDP => 1990-2020 
SELECT * 
FROM t_Marie_Vrbova_project_SQL_secondary_final tmvpssf
WHERE c_country LIKE 'Cz%'AND GDP IS NOT NULL;
SELECT * 


-- spočítáme si procentuální nárůst HDP, cen a mezd a vytvoříme pohled
CREATE OR REPLACE VIEW v_gdp_price_salary AS 
SELECT *
FROM (SELECT 
		tmvpssf.c_country, 
		tmvpssf.year,
		tmvpssf2.year + 1 as gdp_year_prev, 
	    round( ( tmvpssf.GDP - tmvpssf2.GDP ) / tmvpssf2.GDP * 100, 2 ) as GDP_growth_percentage  
	FROM t_Marie_Vrbova_project_SQL_secondary_final tmvpssf 
	INNER JOIN t_Marie_Vrbova_project_SQL_secondary_final tmvpssf2
	    ON tmvpssf.c_country = tmvpssf2.c_country 
	    AND tmvpssf.year = tmvpssf2.year + 1
	    AND tmvpssf.year <= 2018
	    AND tmvpssf.year >= 2006
	WHERE tmvpssf.c_country = 'Czech Republic') AS GDP_table
	INNER JOIN (SELECT DISTINCT
		tmvpspf.product_name, 
		tmvpspf.product_year,
		tmvpspf2.product_year + 1 as year_prev, 
	    round( ( tmvpspf.price_average - tmvpspf2.price_average) / tmvpspf2.price_average * 100, 2 ) as price_growth_percentage,   
	    tmvpspf.industry_branch_name,
	    round( ( tmvpspf.salary_average - tmvpspf2.salary_average) / tmvpspf2.salary_average * 100, 2) as salary_growth_percentage
	FROM t_marie_vrbova_project_sql_primary_final tmvpspf  
	INNER JOIN t_marie_vrbova_project_sql_primary_final tmvpspf2  
	    ON tmvpspf.product_name  = tmvpspf2.product_name  
	    AND tmvpspf.product_year = tmvpspf2.product_year + 1
	    AND tmvpspf.product_year <= 2020
	    AND tmvpspf.product_year >= 2006) AS price_salary_table
	    ON GDP_table.year = price_salary_table.product_year;

-- porovnání GDP s růstem/poklesem cen určitého produktu 
SELECT DISTINCT
	product_name, 
	`year`,
	GDP_growth_percentage,
	price_growth_percentage
FROM v_gdp_price_salary vgps
WHERE product_name = 'Cukr krystalový'; 


SELECT DISTINCT
	industry_branch_name,
	`year` ,
	GDP_growth_percentage,
	salary_growth_percentage
FROM v_gdp_price_salary vgps
WHERE industry_branch_name = 'Zpracovatelský průmysl';

