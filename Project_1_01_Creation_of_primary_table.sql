-- Vytvoření primary tabulky: t_{jmeno}_{prijmeni}_project_SQL_primary_final (pro data mezd a cen potravin za Českou republiku sjednocených na totožné porovnatelné období – společné roky)

-- vytvoření dočasné tabulky se mzdami (salary)
CREATE OR REPLACE TEMPORARY TABLE t_Marie_Vrbova_project_SQL_salary AS
SELECT cp.payroll_year, 
		ROUND(AVG(cp.value)) AS salary_average, 
		cpib.name AS industry_branch_name,
		cpib.code AS code_industry_branch
	FROM czechia_payroll AS cp
	LEFT JOIN czechia_payroll_calculation AS cpc
	    ON cp.calculation_code = cpc.code
	LEFT JOIN czechia_payroll_industry_branch AS cpib
	    ON cp.industry_branch_code = cpib.code
	LEFT JOIN czechia_payroll_unit AS cpu
	    ON cp.unit_code = cpu.code
	LEFT JOIN czechia_payroll_value_type AS cpvt
	    ON cp.value_type_code = cpvt.code
	WHERE cpvt.code = '5958' AND cpvt.code IS NOT NULL
	GROUP BY industry_branch_code, payroll_year 
	ORDER BY payroll_year, industry_branch_code ;	
	   
SELECT *
FROM t_marie_vrbova_project_sql_salary tmvpss ;


-- vytvoření dočasné tabulky s cenami (prices)
CREATE OR REPLACE TEMPORARY TABLE t_Marie_Vrbova_project_SQL_prices AS
SELECT 
	YEAR (cpr.date_from) AS product_year,
	cprcat.name AS product_name,
	ROUND(AVG(cpr.value), 2) AS price_average,
	-- cpr.value, 
	-- cpr.category_code,
	cprcat.price_value,
	cprcat.price_unit
FROM czechia_price cpr
JOIN czechia_price_category AS cprcat
	ON cpr.category_code = cprcat.code 
	GROUP BY cprcat.name, product_year 
	ORDER BY product_year, cprcat.name;

SELECT *
FROM t_Marie_Vrbova_project_SQL_prices;


-- vytvoření finální primary tabulky (s daty mezd a cen potravin za Českou republiku sjednocených na na totožné porovnatelné období) sloučením dočasných tabulek
CREATE OR REPLACE TABLE t_Marie_Vrbova_project_SQL_primary_final AS
(SELECT 
    	*
    FROM t_marie_vrbova_project_sql_salary tmvpss
    INNER JOIN 
    t_marie_vrbova_project_sql_prices tmvpsp
   	ON tmvpss.payroll_year = tmvpsp.product_year); 


SELECT * 
FROM t_marie_vrbova_project_sql_primary_final tmvpspf ;
 

 
 