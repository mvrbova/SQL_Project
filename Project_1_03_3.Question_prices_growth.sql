-- 3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

-- vytvoření pohledu obsahujícího data ohledně cen potravin a výpočet průměrného zvšování cen jednotlivýcch potravin, včetně převedení na procenta
CREATE OR REPLACE VIEW v_price_difference AS 
WITH basic_prices_table AS (SELECT DISTINCT 
			product_year,
			product_name,
			price_average
		FROM t_marie_vrbova_project_sql_primary_final tmvpspf)
SELECT 
	*,
	price_average - LAG(price_average) OVER (PARTITION BY product_name ORDER BY product_name, product_year ASC) AS price_average_growth,
	ROUND((price_average - LAG(price_average) OVER (PARTITION BY product_name ORDER BY product_name, product_year ASC))/LAG (price_average) OVER (PARTITION BY product_name ORDER BY product_name, product_year ASC)*100, 2) AS price_average_percentage_growth
	FROM basic_prices_table;


-- ověření dat v pohledu
SELECT *
FROM v_price_difference;


-- výpočet průměrného percentuálního nárůstu cen podle kategorií
SELECT 
	product_name, 
	AVG (price_average_percentage_growth) AS lowest_percentage_growth
FROM v_price_difference
GROUP BY product_name
ORDER BY lowest_percentage_growth;


-- vypsání dat pro produkt 'Cukr krystalový' a ověření, že zdražoval nejpomaleji, nejnižší percentuální meziroční nárůst
SELECT *
FROM v_price_difference
WHERE product_name = 'Cukr krystalový';



/*SELECT 
	pd.product_name,
	pd.product_year,
	pd.price_average_growth,
	pd2.product_year + 1 AS year_prev,
	pd.price_average_percentage_growth,
	(pd.price_average_percentage_growth - pd2.price_average_percentage_growth) AS perc_growth_year
FROM v_price_difference pd
JOIN v_price_difference pd2
	ON pd.product_name = pd2.product_name
	AND pd.product_year = pd2.product_year + 1
	AND pd.product_year <2019;
*/



/*SELECT 
	pd.product_name,
	pd.product_year,
	pd.price_average_growth,
	pd2.product_year AS year_prev,
	pd.price_average_percentage_growth,
	(pd.price_average_percentage_growth - pd2.price_average_percentage_growth) AS perc_growth_year
FROM v_price_difference pd
JOIN v_price_difference pd2
	ON pd.product_name = pd2.product_name
	AND pd.product_year = pd2.product_year + 1
	AND pd.product_year < 2019;
*/

	

/*SELECT a.product_name, a.price_average_percentage_growth_2007, b.price_average_percentage_growth_2018,
 (b.price_average_percentage_growth_2018 -a.price_average_percentage_growth_2007) AS perc_difference
 FROM (
 SELECT vpd.product_name, vpd.price_average_percentage_growth AS price_average_percentage_growth_2007
 FROM v_price_difference vpd
 WHERE product_year = 2007
 ) a JOIN (
SELECT vpd.product_name, vpd.price_average_percentage_growth AS price_average_percentage_growth_2018
 FROM v_price_difference vpd
 WHERE product_year = 2018 ) b
 ON a.product_name = b.product_name
 ORDER BY perc_difference DESC;
*/ 
 
/*
 * 
 SELECT DISTINCT *, AVG(price_average_percentage_growth)
FROM v_price_difference 
GROUP BY product_name, product_year ;
*/