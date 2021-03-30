USE orders;

/*Q 7 Write a query to display carton id, (len*width*height) as carton_vol and identify 
the optimum carton (carton with the least volume whose volume is greater than the total volume 
of all items (len * width * height * product_quantity)) for a given order whose order id is 10006, 
Assume all items of an order are packed into one single carton (box). (1 ROW) [NOTE: CARTON TABLE]*/
SELECT 
    carton_id, len * width * height AS Carton_Vol
FROM
    carton
WHERE
    len * width * height > /*Sub query to fetch total volume of all items in order id 10006*/
    (SELECT 
            SUM(p.len * p.width * p.height * oi.product_quantity) AS Total_Vol
        FROM
            order_items AS oi
                INNER JOIN
            product AS p
        WHERE
            oi.product_id = p.product_id
                AND oi.order_id = 10006)
ORDER BY Carton_Vol
LIMIT 1;
/* The optimum carton is carton ID 40 with volume 1215000000*/

/*Q8. Write a query to display details (customer id,customer fullname,order id,product quantity) 
of customers who bought more than ten (i.e. total order qty) products per shipped order. (11 ROWS) 
[NOTE: TABLES TO BE USED - online_customer, order_header, order_items,]*/
SELECT 
    oc.customer_id,
    CONCAT(oc.customer_fname,
            ' ',
            oc.customer_lname) 'customer_fullname',
    oh.order_id,
    SUM(oi.product_quantity) AS Total_Product_Quantity
FROM
    online_customer oc
        INNER JOIN
    ORDER_HEADER AS oh ON oc.CUSTOMER_ID = oh.CUSTOMER_ID
        INNER JOIN
    order_items AS oi ON oh.ORDER_ID = oi.ORDER_ID
WHERE
    oh.ORDER_STATUS = 'Shipped'
GROUP BY oi.order_id
HAVING Total_Product_Quantity > 10;

/*Q9 Write a query to display the order_id, customer id and cutomer full name of customers 
along with (product_quantity) as total quantity of products shipped for order ids > 10060. (6 ROWS) 
[NOTE: TABLES TO BE USED - online_customer, order_header, order_items]*/
SELECT 
    oc.customer_id,
    CONCAT(oc.customer_fname,
            ' ',
            oc.customer_lname) 'customer_fullname',
    oh.order_id,
    SUM(oi.product_quantity) AS Total_Product_Quantity
FROM
    online_customer oc
        INNER JOIN
    ORDER_HEADER AS oh ON oc.CUSTOMER_ID = oh.CUSTOMER_ID
        INNER JOIN
    order_items AS oi ON oh.ORDER_ID = oi.ORDER_ID
WHERE
    oh.ORDER_STATUS = 'Shipped'
        AND oh.order_id > 10060
GROUP BY oh.order_id;

/*10. Write a query to display product class description ,total quantity (sum(product_quantity),
Total value (product_quantity * product price) and show which class of products have been shipped 
highest(Quantity) to countries outside India other than USA? Also show the total value of those items. 
(1 ROWS)[NOTE:PRODUCT TABLE,ADDRESS TABLE,ONLINE_CUSTOMER TABLE,ORDER_HEADER TABLE,ORDER_ITEMS TABLE,PRODUCT_CLASS TABLE]*/
SELECT 
    pc.product_class_desc,
    SUM(oi.product_quantity) AS Total_Product_Quantity,
    SUM(oi.product_quantity * p.product_price) AS Total_value
FROM
    online_customer AS oc
        INNER JOIN
    ADDRESS AS ad ON oc.ADDRESS_ID = ad.ADDRESS_ID
        INNER JOIN
    ORDER_HEADER AS oh ON oc.CUSTOMER_ID = oh.CUSTOMER_ID
        INNER JOIN
    order_items AS oi ON oh.ORDER_ID = oi.ORDER_ID
        INNER JOIN
    product AS p ON oi.PRODUCT_ID = p.PRODUCT_ID
        INNER JOIN
    product_class AS pc ON p.PRODUCT_CLASS_CODE = pc.PRODUCT_CLASS_CODE
WHERE
    oh.ORDER_STATUS = 'Shipped'
        AND ad.country NOT IN ('India' , 'USA')
GROUP BY pc.product_class_desc
ORDER BY SUM(oi.product_quantity) DESC
LIMIT 1;
/*Stationery items have been bought the maximum number of times*/