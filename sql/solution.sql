SELECT customer_id, SUM(m.price) 
AS total_amount from Sales s INNER JOIN
Menu m ON s.product_id = m.product_id GROUP BY customer_id



SELECT customer_id , COUNT(DISTINCT order_date) AS visit_days FROM
Sales GROUP BY customer_id

SELECT s.customer_id, m.product_name FROM Sales s JOIN(
SELECT customer_id, MIN(order_date) AS first_order_date
FROM Sales GROUP BY customer_id ) f ON
f.first_order_date = s.order_date AND
s.customer_id = f.customer_id JOIN 
Menu m on s.product_id = m.product_id



SELECT m.product_name, COUNT(*) AS purchased_times
FROM Sales s
JOIN Menu m ON s.product_id = m.product_id
GROUP BY m.product_name
ORDER BY purchased_times DESC



SELECT customer_id , product_name , purchased_count FROM
(
SELECT s.customer_id, m.product_name ,
COUNT(*) AS purchased_count,
RANK() OVER (PARTITION BY s.customer_id ORDER BY COUNT(*) DESC)
AS rnk 
FROM Sales s 
JOIN MENU m ON s.product_id = m.product_id 
GROUP BY s.customer_id, m.product_name
)ranked  
WHERE rnk = 1;



SELECT s.customer_id, m.product_name FROM Sales s JOIN (
SELECT s.customer_id, MIN(order_date) first_after_join FROM Sales s 
JOIN Members m ON s.customer_id = m.customer_id
WHERE s.order_date > m.join_date
GROUP BY s.customer_id ) f
ON s.customer_id = f.customer_id AND s.order_date = f.first_after_join
JOIN Menu m ON s.product_id = m.product_id


SELECT s.customer_id, m.product_name FROM Sales s JOIN (
SELECT s.customer_id, MAX(order_date) first_after_join FROM Sales s 
JOIN Members m ON s.customer_id = m.customer_id
WHERE s.order_date < m.join_date
GROUP BY s.customer_id ) f
ON s.customer_id = f.customer_id AND s.order_date = f.first_after_join
JOIN Menu m ON s.product_id = m.product_id



SELECT s.customer_id, SUM(m.price) AS total_price, COUNT(m.product_id)AS total_product 
FROM Sales s
JOIN Members mb ON s.customer_id = mb.customer_id
JOIN Menu m ON s.product_id = m.product_id 
WHERE 
s.order_date < mb.join_date
GROUP BY s.customer_id


SELECT s.customer_id, 
SUM(CASE WHEN m.product_name = 'sushi' THEN price*20 ELSE price*10 END) 
AS points FROM Sales s JOIN 
Menu m ON s.product_id = m.product_id 
GROUP BY s.customer_id


SELECT s.customer_id , SUM(
CASE
WHEN s.order_date BETWEEN mb.join_date AND DATEADD(DAY,6, mb.join_date)
THEN m.price*20 
WHEN m.product_name = 'sushi' THEN m.price*20
ELSE m.price*10 
END) AS total_points
FROM Sales s 
JOIN Members mb ON s.customer_id = mb.customer_id
JOIN Menu m ON m.product_id = s.product_id 
WHERE s.order_date <= '2021-01-31' AND s.customer_id IN ('A', 'B')
GROUP BY s.customer_id


SELECT s.customer_id, s.order_date,m.product_name,m.price , CASE WHEN 
mb.join_date IS NOT NULL THEN 'Y' ELSE 'N' END AS member
FROM Sales s 
JOIN Menu m ON s.product_id = m.product_id  
LEFT JOIN Members mb ON s.customer_id = mb.customer_id 


SELECT s.customer_id, s.order_date,m.product_name,m.price , CASE WHEN 
mb.join_date IS NOT NULL THEN 'Y' ELSE 'N' END AS member ,
CASE WHEN s.order_date >= mb.join_date THEN 
RANK() OVER (PARTITION BY  s.customer_id ORDER BY s.order_date)
    ELSE NULL END AS ranking
FROM Sales s 
JOIN Menu m ON s.product_id = m.product_id  
LEFT JOIN Members mb ON s.customer_id = mb.customer_id 

