/* SCHEMA AND TABLES */

CREATE SCHEMA sales;

CREATE TABLE sales.states(
	id serial primary key NOT NULL,
	name varchar(50) NOT NULL
);

CREATE TABLE sales.categories(
	id serial primary key NOT NULL,
	name varchar(50) NOT NULL,
	description text
);
                
CREATE TABLE sales.customers(
	id serial primary key NOT NULL,
	f_name varchar(50) NOT NULL,
	l_name varchar(50) NOT NULL,
	state_id integer references sales.states(id) NOT NULL
);
                
CREATE TABLE sales.products(
	id serial primary key NOT NULL,
	name varchar(50) NOT NULL,
	price numeric NOT NULL,
	category_id integer references sales.categories(id)
);

                
CREATE TABLE sales.sales(
	id serial primary key NOT NULL,
	price numeric NOT NULL,
	quantity integer NOT NULL,
	customer_id integer references sales.customers(id) NOT NULL,
	product_id integer references sales.products(id) NOT NULL,
	discount numeric NOT NULL
);
	
	
/* QUERY 1 */
SELECT c.id, sum(quantity) AS total_quantity, sum(price) AS total_value
FROM sales.sales s 
NATURAL JOIN sales.customers c 
GROUP BY c.id;

/* QUERY 2 */
SELECT st.name, sum(quantity) AS total_quantity, sum(price) AS total_value
FROM sales.sales s 
NATURAL JOIN sales.customers c 
NATURAL JOIN sales.states st 
GROUP BY st.name;

/* QUERY 3 */
SELECT product_id, sum(quantity) AS total_quantity, sum(price) AS total_value
FROM sales.sales s 
WHERE customer_id = 999
GROUP BY product_id 
ORDER BY total_value;
    
/* QUERY 4 */
SELECT product_id, customer_id, sum(price) AS total_value 
FROM sales.sales 
GROUP BY product_id, customer_id 
ORDER BY total_value DESC;
         
/* QUERY 5 */
SELECT ca.id, st.name, sum(s.price) AS total_value
FROM sales.sales s
NATURAL JOIN sales.customers cu
NATURAL JOIN sales.states st 
JOIN sales.products pr
	ON s.product_id = pr.id
JOIN sales.categories ca
	ON ca.id = pr.category_id
GROUP BY ca.id, st.name;
    
/* QUERY 6 */
SELECT top_ca.id, top_cu.customer_id, sum(s.quantity), sum(s.price) 
FROM 
	(SELECT ca.id AS id, sum(s.price) AS total_value 
	FROM sales.categories ca
	JOIN sales.products pr 
		ON ca.id = pr.category_id
	JOIN sales.sales s
		ON pr.id = s.product_id
	GROUP BY ca.id 
	ORDER BY total_value DESC limit 20) AS top_ca, 
              
	(SELECT customer_id, sum(price) AS dollar_value 
	FROM sales.sales
	GROUP BY customer_id 
	ORDER BY dollar_value DESC limit 10) AS top_cu, 
              
	sales.sales s, sales.products pr
                    
WHERE pr.category_id = top_ca.id 
		and s.customer_id = top_cu.customer_id 
		and s.product_id = pr.id
GROUP BY top_ca.id, top_cu.customer_id 
ORDER BY top_ca.id;