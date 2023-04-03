{\rtf1\ansi\ansicpg1252\cocoartf2638
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 \
USE ROLE accountadmin;\
USE WAREHOUSE compute_wh;\
USE DATABASE yelp;\
USE SCHEMA public;\
\
-- Part A Question 1 [40 points]\
DROP VIEW category_average_rating;\
\
CREATE VIEW category_average_rating AS\
SELECT count(distinct cA.business_id)as NUM_DISTINCT_RESTAURANTS, cB.category_name\
FROM category cA\
	INNER JOIN category cB ON cA.business_id = cB.business_id\
WHERE cA.category_name = 'Restaurants' \
GROUP BY cB.category_name \
HAVING NUM_DISTINCT_RESTAURANTS > 100;\
SELECT * FROM category_average_rating;\
\
CREATE VIEW category_average_rating2 AS\
SELECT category_name, NUM_DISTINCT_RESTAURANTS, AVG(r.stars) AS category_avg_rating\
FROM category_average_rating\
INNER JOIN category c USING (category_name)\
INNER JOIN review r USING (business_id)\
GROUP BY category_name, NUM_DISTINCT_RESTAURANTS\
order by category_name asc, AVG(r.stars) desc, NUM_DISTINCT_RESTAURANTS desc;\
SELECT * FROM category_average_rating2;\
\
-- Part A Question 2 [40 points]\
\
\
DROP VIEW IF EXISTS business_avg_rating;\
CREATE VIEW business_avg_rating AS\
SELECT business_id, name, AVG(r.stars) as business_average_rating\
FROM review r\
INNER JOIN business b USING (business_id)\
INNER JOIN category c USING (business_id)\
WHERE c.category_name = 'Restaurants'\
GROUP BY business_id, name;\
SELECT * FROM business_avg_rating;\
\
SELECT business_id, name, AVG(r.stars), \
FROM business\
INNER JOIN business_avg_rating using(business_id)\
GROUP BY business_id, name\
order by business_id, name asc;\
\
SELECT business_id, name, business_average_rating, MAX(category_avg_rating)\
FROM category_average_rating2\
INNER JOIN category USING (category_name)\
INNER JOIN business_avg_rating USING (business_id)\
GROUP BY business_id, name, business_average_rating\
HAVING business_average_rating > MAX(category_avg_rating)\
ORDER BY name asc, MAX(category_avg_rating) desc,business_average_rating desc; }