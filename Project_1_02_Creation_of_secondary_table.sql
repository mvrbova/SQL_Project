-- Vytvoření secondary tabulky: t_{jmeno}_{prijmeni}_project_SQL_secondary_final (pro dodatečná data o dalších evropských státech)

-- propojení tabulek countries a economies 
CREATE OR REPLACE TABLE t_Marie_Vrbova_project_SQL_secondary_final AS
(SELECT 
    	c.country AS c_country,
    	e.YEAR,
    	c.continent,
    	-- c.currency_name,
    	c.currency_code,
    	-- e.country AS e_country,
    	e.GDP,
    	e.GINI
    FROM countries c
    INNER JOIN 
    economies e 
   	ON c.country = e.country); 




