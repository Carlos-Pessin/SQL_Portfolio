/*
# Challenge:
Business problem: Tracking Sales Quota Progress over Time
The sales team works diligently to sell the product, and they have quotas that they must reach in order to earn all of their commission.
Because these goals are so intimately tied to revenue, the manager of the team wants to track each sales member's performance throughout the year.
You suggest a % of quota reached metric that could be displayed on a dashboard, but the sales manager expresses her concern that a
single metric won't give her visibility into their progress throughout the year. You suggest providing a running_total of sales revenue and a
percent_quota metric that will be recalculated every time a sales member makes another sale. She agrees, and you get started!

Task:
Calculate the running total of sales revenue, running_total, and the % of quota reached, percent_quota, for each sales employee on each date they make a sale. 
Use the sales and employees table to pull in and create the following fields:
- salesemployeeid
- saledate
- saleamount
- quota
- running_total
- percent_quota
Order the final output by salesemployeeid and saledate
*/

SELECT
    s.SALESEMPLOYEEID,
    s.SALEDATE,
    s.SALEAMOUNT,
    SUM(SALEAMOUNT) OVER(PARTITION BY SALESEMPLOYEEID ORDER BY SALEDATE ASC) AS RUNNING_TOTAL,
    CAST(SUM(SALEAMOUNT) OVER(PARTITION BY SALESEMPLOYEEID ORDER BY SALEDATE ASC) AS FLOAT)/CAST(QUOTA AS float) AS PERCENT_QUOTA,
FROM
    Employees e
LEFT JOIN
    Sales s ON e.EMPLOYEEID = s.SALESEMPLOYEEID
WHERE
    DEPARTMENT = 'Sales'
ORDER BY
    SALESEMPLOYEEID
