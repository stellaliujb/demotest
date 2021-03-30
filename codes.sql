---what were weekly sales in 2021
ALTER SESSION SET week_start = 7;
SELECT date(date_trunc('week', ORDER_DATE_PDT)) AS Frist_DATE_OF_WEEK, 
SUM(GROSS_REVENUE)AS GROSS_REVENUE,SUM(GROSS_REVENUE_AFTER_DISCOUNTS)AS GROSS_REVENUE_AFTER_DISCOUNTS
FROM TL_DS_SANDBOX.NEW_SALES.FCT_ORDER_LINE
where (date(ORDER_DATE_PDT)>='2021-01-01'AND ORDER_TYPE<>'exchange')
GROUP BY Frist_DATE_OF_WEEK
ORDER BY Frist_DATE_OF_WEEK;

---how many new customers in 2021 by week
SELECT 
date(date_trunc('week', ORDER_DATE_PDT)) AS First_DATE_OF_WEEK, 
COUNT (distinct CUSTOMER_ID) AS COUNT_NEW_CUSTOMER
FROM TL_DS_SANDBOX.NEW_SALES.FCT_ORDER_LINE
WHERE NEW_REPEAT='new' and date(ORDER_DATE_PDT)>='2021-01-01'
GROUP BY 1
ORDER BY 1;

---how many daily sessions february ga4 data
SELECT 
DATE (SESSION_START_TIME)AS SESSION_DATE,
COUNT (GA_SESSION_ID)
FROM TL_DS_SANDBOX.JASON.GOOGLE_SESSIONS
WHERE SESSION_DATE > '2021-01-31' AND SESSION_DATE<'2021-03-01'
GROUP BY 1
ORDER BY 1 DESC;

SELECT *
FROM TL_DS_SANDBOX.JASON.GOOGLE_SESSIONS
WHERE DATE (SESSION_START_TIME) > '2021-01-31' AND DATE (SESSION_START_TIME)<'2021-03-01'
ORDER BY 2 DESC;

--cohort features
select 
  customer_id
, Min(DATE(ORDER_DATE_PDT))AS cohort_date
, date_trunc('month',Min(DATE(ORDER_DATE_PDT))) AS cohort_month
, date_trunc('quarter',Min(DATE(ORDER_DATE_PDT))) AS cohort_quarter
, case when date_part('month', cohort_month) in (1,2,3,4,5,6)
     then to_date(concat(date_part('year', cohort_month), '-01-01'))
     else to_date(concat(date_part('year', cohort_month), '-06-01'))
     end as cohort_half_year
, date_trunc('year',Min(DATE(ORDER_DATE_PDT))) AS cohort_year
from TL_DS_SANDBOX.NEW_SALES.FCT_ORDER_LINE
where order_type='sale'
group by 1;

--tweaks to make it more readable
select 
  customer_id
, min(ORDER_DATE_PDT)::date AS cohort_date
, min(date_trunc('month',ORDER_DATE_PDT))::date AS cohort_month
, min(date_trunc('quarter', ORDER_DATE_PDT))::date AS cohort_quarter
, case when date_part('month', cohort_month) in (1,2,3,4,5,6)
     then to_date(concat(date_part('year', cohort_month), '-01-01'))
     else to_date(concat(date_part('year', cohort_month), '-06-01'))
     end as cohort_half_year
, min(date_trunc('year', ORDER_DATE_PDT))::date AS cohort_year
from TL_DS_SANDBOX.NEW_SALES.FCT_ORDER_LINE
where order_type='sale'
group by 1
