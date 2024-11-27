/*
# Challenge:
Business problem: Comparing MoM Revenue
It's time for end-of-year reporting, and your manager wants you to put together a slide deck summarizing the top revenue
highlights of the year and present it to the whole company on the all-hands call. Among other metrics and insights, 
your manager suggests that you highlight months where revenue was up month-over- month (MoM). In other words, she wants
you to highlight the months where revenue was up from the previous month. You know this can be done with window functions using lead or
lag, but you decide to exercise your self join skills to accomplish the task.

Task:
Pull a report that includes the following fields:
- current_month: the current month
- previous_month: the previous month from the current month current_revenue: the monthly revenue of the current month
- previous_revenue: the monthly revenue of the previous month
Only pull rows where the monthly revenue for the current month is greater than the revenue for the previous month.
Filter the data so that the date difference (in months) between the current month and previous month is 1.
*/

WITH Monthly_Result AS (
SELECT
    DATE_TRUNC('MONTH', ORDERDATE) AS CURRENT_MONTH,
    DATEADD('month', -1, DATE_TRUNC('MONTH', ORDERDATE)) AS PREVIOUS_MONTH,
    SUM(REVENUE) AS CURRENT_REVENUE
FROM
    Subscriptions
GROUP BY
    CURRENT_MONTH, PREVIOUS_MONTH
)

SELECT
    m1.*,
    m2.CURRENT_REVENUE AS PREVIOUS_REVENUE
FROM
    Monthly_Result m1
JOIN
    Monthly_Result m2 ON m1.PREVIOUS_MONTH = m2.CURRENT_MONTH
WHERE
    m1.CURRENT_REVENUE > m2.CURRENT_REVENUE
