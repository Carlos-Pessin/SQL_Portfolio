/* Challenge
The product manager has requested a payment funnel analysis from the analytics team; she wants to understand what the furthest point in the payment process users are getting to and where
users are falling out of the process. She wants to have full visibility into each possible stage of the payment process from the user's point of view.
Here's the payment process a user goes through when signing up for a subscription:
1. The user opens the widget to initiate payment process.
2. The user types in credit card information.
3. The user clicks the submit button to complete their part of the payment process.
4. The product sends the data to the third-party payment processing company.
5. The payment company completes the transaction and reports back with "complete."
As subscriptions move through the statuses, the movements are logged in the paymentstatuslog table using the statusid. Users can go back and forth and move through statuses multiple times.
Check out the example below for subscriptionid '38844*. Notice how they move through a few statuses, hit an error, restart the process, and then finally complete their payment.

Creating the paymentfunnelstage logic:
To determine a subscription's payment funnelstage, we want to consider its max statusid because this will show us the furthest point in the workflow that they successfully reached-regardless of whether they:
- completed the process,
- hit an error and started the process over,
- or hit an error, gave up, and left the workflow.
In addition to the max status reached, we also want to consider if the subscription is currently stuck in an error using the currentstatus column from the subscriptions table.
If a user reaches statusid = 3 but submits an incorrect card number, the transaction will be stopped and they will see an error message. The user will then need to restart the process
and use the correct information. This is considered a user error. If a user reaches statusid = 4 and submits correct payment information, the data is sent to a third-party payment company.
If they are unable to process the data and complete the transaction due to an error on their end, it will produce an error message to the user. This is considered a vendor error.

Task:
Count the number of subscriptions in each payment funnelstage as outlined in the code that I've given you by incorporating the the maxstatus reached and
currentstatus per subscription. Use the paymentstatuslog and subscriptions tables.
*/

WITH Payment_Status AS (
SELECT
    SUBSCRIPTIONID,
    MAX(STATUSID) AS MAXSTATUS
FROM
    PaymentStatusLog
GROUP BY
    SUBSCRIPTIONID
)


SELECT
    CASE
        WHEN MAXSTATUS = 1 THEN 'PaymentWidgetOpened'
        WHEN MAXSTATUS = 2 THEN 'PaymentEntered'
        WHEN MAXSTATUS = 3 AND CURRENTSTATUS = 0 THEN 'User Error with Payment Submission'
        WHEN MAXSTATUS = 3 AND CURRENTSTATUS != 0 THEN 'Payment Submitted'
        WHEN MAXSTATUS = 4 AND CURRENTSTATUS = 0 THEN 'Payment Processing Error with Vendor'
        WHEN MAXSTATUS = 4 AND CURRENTSTATUS != 0 THEN 'Payment Success'
        WHEN MAXSTATUS = 5 THEN 'Complete'
        WHEN MAXSTATUS IS NULL THEN 'User did not start payment process'
    END AS PAYMENTFUNNELSTAGE,
    COUNT(s.SUBSCRIPTIONID) AS SUBSCRIPTIONS
FROM
    Subscriptions s
LEFT JOIN
    Payment_Status p ON s.SUBSCRIPTIONID = p.SUBSCRIPTIONID
GROUP BY
    PAYMENTFUNNELSTAGE

