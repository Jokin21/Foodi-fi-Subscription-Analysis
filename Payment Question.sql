# Challenge payment Question.

select 
s.customer_id,
p.plan_id,
p.plan_name,
s.start_date
from subscription s
inner join plans p on s.plan_id = p.plan_id;

create table payments as
with payment as (
    SELECT
      s.customer_id as customer_id,
      s.plan_id as plan_id,
      p.plan_name as plan_name,
      
      CASE
          WHEN s.plan_id = 1 THEN s.start_date
          WHEN s.plan_id = 2 THEN s.start_date
          WHEN s.plan_id = 3 THEN s.start_date
          WHEN s.plan_id = 4 THEN NULL
          ELSE '2020-12-31' 
        END AS payment_date,
      price AS amount
    FROM
      subscription AS s
      JOIN plans AS p ON s.plan_id = p.plan_id
    WHERE
      s.plan_id != 0
      AND s.start_date < '2021-01-01' 
    GROUP BY
      s.customer_id,
      s.plan_id,
      p.plan_name,
      s.start_date,
      p.price
	ORDER BY
	  s.customer_id)

SELECT
  customer_id,
  plan_id,
  plan_name,
  payment_date,
  CASE
    WHEN LAG(plan_id) OVER (
      PARTITION BY customer_id
      ORDER BY
        plan_id
    ) != plan_id
    AND (
      DATEDIFF(payment_date, LAG(payment_date) OVER (
        PARTITION BY customer_id
        ORDER BY
          plan_id
      ))
    ) < 30 THEN amount - LAG(amount) OVER (
      PARTITION BY customer_id
      ORDER BY
        plan_id
    )
    ELSE amount
  END AS amount,
  RANK() OVER(
    PARTITION BY customer_id
    ORDER BY payment_date
  ) AS payment_order 
  from payment
  order by customer_id,plan_id;
  
  select * from payments;
