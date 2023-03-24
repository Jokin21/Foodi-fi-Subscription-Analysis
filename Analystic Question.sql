## PART `B

USE foodie;

# 1. How many customers has Foodie-Fi ever had?

SELECT COUNT(distinct customer_id) AS UNIQUE_CUSTOMERS FROM subscription;

# 2. What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value
SELECT MONTH(start_date) AS MONTHS,
COUNT(customer_id) AS NUM_CUSTOMERS
FROM subscription
GROUP BY MONTH(start_date);

# 3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name
SELECT 
 p.plan_id,
 p.plan_name,
 COUNT(*) AS COUNT_OF_EVENT
 FROM subscription s
 JOIN plans p ON p.plan_id = s.plan_id
 WHERE s.start_date >= "2021-01-01"
 GROUP BY plan_id,plan_name;
 
# 4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
SELECT COUNT(*) AS CHURN_CUSTOMERS, 
ROUND(COUNT(*) * 100 / (SELECT COUNT(DISTINCT customer_id) FROM subscription),1)
as percentage_of_customers
FROM subscription
WHERE plan_id = 4 ;

# 5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?

-- Find ranking of plans by customer and plan type

WITH ranking AS (
SELECT 
  s.customer_id, 
  s.plan_id, 
  p.plan_name,
  -- Run a ROW_NUMBER() to rank the plans from 0 to 4
  ROW_NUMBER() OVER (
    PARTITION BY s.customer_id 
    ORDER BY s.plan_id) 
    AS plan_rank 
FROM subscription s
JOIN plans p
ON s.plan_id = p.plan_id)
  
SELECT 
  COUNT(*) AS churn_count,
  ROUND(100 * COUNT(*) / (
    SELECT COUNT(DISTINCT customer_id) 
    FROM subscription),0) AS churn_percentage
FROM ranking
WHERE plan_id = 4 AND plan_rank = 2; 

# 6. What is the number and percentage of customer plans after their initial free trial?

WITH next_plan_cte AS (
SELECT customer_id, plan_id, 
LEAD(plan_id, 1) OVER( -- Offset by 1 to retrieve the immediate row's value below 
PARTITION BY customer_id 
ORDER BY plan_id) next_plan
FROM subscription)

SELECT next_plan, 
COUNT(*) conversions,
ROUND(COUNT(*)*100 / (SELECT COUNT(DISTINCT customer_id) 
FROM Subscription),0) conversion_percentage
FROM next_plan_cte
WHERE next_plan IS NOT NULL 
AND plan_id = 0
GROUP BY next_plan
ORDER BY next_plan;
  
# 7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?

WITH next_plan AS(
SELECT customer_id, plan_id, start_date,
LEAD(start_date, 1) OVER(PARTITION BY customer_id ORDER BY start_date) as next_date
FROM subscription
WHERE start_date <= '2020-12-31'),
      
-- Find customer breakdown with existing plans on or after 31 Dec 2020

customer_breakdown AS (
SELECT plan_id, 
COUNT(DISTINCT customer_id) AS customers
FROM next_plan
WHERE (next_date IS NOT NULL AND (start_date < '2020-12-31' 
AND next_date > '2020-12-31'))
OR (next_date IS NULL AND start_date < '2020-12-31')
GROUP BY plan_id)

SELECT plan_id, customers, 
ROUND(100 * customers / (
SELECT COUNT(DISTINCT customer_id) 
FROM subscription),1) AS percentage
FROM customer_breakdown 
GROUP BY 
plan_id, customers
ORDER BY plan_id;

# 8. How many customers have upgraded to an annual plan in 2020?

SELECT 
COUNT(customer_id) AS no_of_customers FROM subscription
WHERE plan_id = 3 AND start_date  <= '2020-12-31' ; 

# 9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?

-- Filter results to customers at trial plan = 0

WITH trial_plan AS 
  (SELECT customer_id, start_date AS trial_date
FROM foodie.subscription
WHERE plan_id = 0
),
-- Filter results to customers at pro annual plan = 3
annual_plan AS
(SELECT customer_id,  start_date AS annual_date
FROM foodie.subscription
WHERE plan_id = 3
)

SELECT 
ROUND(AVG(annual_date - trial_date),0) AS avg_days_to_upgrade
FROM trial_plan tp
JOIN annual_plan ap
ON tp.customer_id = ap.customer_id;
  
# 10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)

WITH trial_plan AS 
  (
  SELECT customer_id, start_date AS trial_date
FROM subscription
WHERE plan_id = 0
),
-- Filter results to customers at pro annual plan = 3

annual_plan AS
(SELECT customer_id, start_date AS annual_date
FROM subscription
WHERE plan_id = 3
),
time_lapse_tb as (
SELECT tp.customer_id, tp.trial_date, ap.annual_date,
DATEDIFF(ap.annual_date,tp.trial_date) as diff
FROM trial_plan tp
LEFT JOIN annual_plan ap
ON tp.customer_id = ap.customer_id
WHERE annual_date IS NOT NULL
),
bins  AS (
SELECT *,
FLOOR(diff/30) AS bins
FROM time_lapse_tb)

SELECT 
CONCAT((bins*30)+1,'-',(bins+1)*30,'days') AS Days,
COUNT(diff) AS Total
FROM bins
GROUP BY bins;


# 11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?
-- Retrieve next plan's start date located in the next row based on current row

WITH next_plan_cte AS (
SELECT customer_id, plan_id, start_date,
LEAD(plan_id, 1) OVER(
PARTITION BY customer_id 
ORDER BY plan_id) as next_plan
FROM foodie.subscription)

SELECT 
COUNT(*) AS downgraded
FROM next_plan_cte
WHERE start_date <= '2020-12-31'
AND plan_id = 2 
AND next_plan = 1;










 
 