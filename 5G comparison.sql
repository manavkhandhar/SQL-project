--this dataset contains information of user metrics, revenue, in different cities of a telecom company. 

/* AtliQo is one of the leading telecom providers in India and launched its 5G plans in May 2022 along with other telecom providers.

The management noticed a decline in their active users and revenue growth post 5G launch in May 2022. 
AtliQo’s business director requested their analytics team to provide a comparison report
of KPIs between pre and post-periods of the 5G launch.

The management is keen to compare the performance between these periods 
and get insights that would enable them to make informed decisions 
to recover their active user rate and other key metrics. 

I am assigned to this task as a junior data analyst.

Skills used for this project - SQL basics, JOIN functions, AGGREGATE functions, 
Database modifications, case when functions, UNION functions. 

START---

-- joined two tables to know the total market value for the cities. 
*/
select date, city_name, tmv_city_crores, company, ms_pct
from market_share
INNER join dim_cities
ON market_share.city_code = dim_cities.city_code

-- overview of revenue from cities by joining two tables

SELECT date, city_name, plans, plan_revenue_crores from plan_revenue
INNER JOIN dim_cities
ON plan_revenue.city_code = dim_cities.city_code
order BY plans

-- overview of metrics for Atliqo PLAN-WISE

SELECT * from plan_revenue
ORDER BY plans ASC

-- city-wise total revenue for Atliqo in crores

SELECT city_name, sum(atliqo_revenue_crores) AS total_rev from metrics
LEFT JOIN dim_cities
ON metrics.city_code = dim_cities.city_code
group by dim_cities.city_name
ORDER by total_rev DESC

--city-wise average revenue for Atliqo in crores

SELECT city_name, avg(atliqo_revenue_crores) AS avg_rev from metrics
LEFT JOIN dim_cities
ON metrics.city_code = dim_cities.city_code
group by dim_cities.city_name
ORDER by avg_rev DESC

--city wise average arpu (Average Revenue Per User)

SELECT city_name, avg(arpu) AS avg_arpu from metrics
LEFT JOIN dim_cities
ON metrics.city_code = dim_cities.city_code
group by dim_cities.city_name
ORDER by avg_arpu DESC

--showing metrics before 5G implementation

SELECT date, atliqo_revenue_crores, arpu, active_users_lakhs, unsubscribed_users_lakhs from metrics
where date  IN('2022-01-01','2022-02-01','2022-03-01','2022-04-01') 

--showing metrics after 5G implementation

SELECT date, atliqo_revenue_crores, arpu, active_users_lakhs, unsubscribed_users_lakhs from metrics
where date  IN('2022-06-01','2022-07-01','2022-08-01','2022-09-01') 

-- total active users in lakhs, city-wise

SELECT city_name, sum(active_users_lakhs) AS active_total_lakhs from metrics
LEFT JOIN dim_cities
ON metrics.city_code = dim_cities.city_code
group by dim_cities.city_name
ORDER by active_total_lakhs DESC

-- total unsubscribed users in lakhs, city-wise

SELECT city_name, sum(unsubscribed_users_lakhs) AS unsub_total_lakhs from metrics
LEFT JOIN dim_cities
ON metrics.city_code = dim_cities.city_code
group by dim_cities.city_name
ORDER by unsub_total_lakhs DESC

-- average of monthly active users in lakhs 

select month_name, avg(active_users_lakhs) AS mau_lakhs, before_after_5g from dim_date
INNER JOIN metrics
ON dim_date.[date] = metrics.[date]
where before_after_5g  IN('Before 5G','After 5G')
group by dim_date.month_name, before_after_5g, time_period
order by time_period ASC

-- average of monthly unsubscribers in lakhs 

select month_name, avg(unsubscribed_users_lakhs) AS unsub_avg_lakhs, before_after_5g from dim_date
INNER JOIN metrics
ON dim_date.[date] = metrics.[date]
where before_after_5g  IN('Before 5G','After 5G')
group by dim_date.month_name, before_after_5g, time_period
order by time_period asc 

-- plan-wise monthly revenue in crores
SELECT date, plans, sum(plan_revenue_crores) as total_revenue_cr from plan_revenue 
GROUP BY [date], plans
ORDER BY plans ASC

--aggregate plan revenue
SELECT plans, sum(plan_revenue_crores) AS agg_plan_revenue from plan_revenue
group by plans 
order by plans ASC

-- average of market share % 

SELECT company, city_name, avg(ms_pct) AS avg_ms_pct from market_share
LEFT JOIN dim_cities
ON market_share.city_code = dim_cities.city_code
group by dim_cities.city_name, company
ORDER by avg_ms_pct DESC

-- average of market share % for Atliqo

SELECT company, city_name, avg(ms_pct) AS avg_ms_pct from market_share
LEFT JOIN dim_cities
ON market_share.city_code = dim_cities.city_code
where market_share.company = 'Atliqo'
group by dim_cities.city_name, company
ORDER by avg_ms_pct DESC

-- revenue and arpu BEFORE 5G

select company, sum(atliqo_revenue_crores) AS revenue_before_5G, avg(arpu) AS arpu_before_5G from metrics
LEFT JOIN dim_date
ON metrics.date = dim_date.DATE
where month_name IN('Jan','Feb','Mar','Apr')
group by company

-- revenue and arpu AFTER 5G

select company, sum(atliqo_revenue_crores) AS revenue_after_5G, avg(arpu) AS arpu_after_5G from metrics
LEFT JOIN dim_date
ON metrics.date = dim_date.DATE
where month_name IN('Jun','Jul','Aug','Sep')
group by company

-- when we compare the metrics for total revenue and arpu pre and post 5G implementation, 
-- the total revenue has fallen post 5G implementation but the average revenue per user (arpu) saw an increase from 190 to 211. 


-- active users BEFORE 5G 

select company, sum(active_users_lakhs) AS lakh_users_after_5G from metrics
LEFT JOIN dim_date
ON metrics.date = dim_date.DATE
where month_name IN('Jan','Feb','Mar','Apr')
group by company

-- active users AFTER 5G

select company, sum(active_users_lakhs) AS lakh_users_before_5G from metrics
LEFT JOIN dim_date
ON metrics.date = dim_date.DATE
where month_name IN('Jun','Jul','Aug','Sep')
group by company

-- plan revenue (in crores) comparison BEFORE 5G

SELECT month_name, plans, sum(plan_revenue_crores) AS plan_rev_pre5G from plan_revenue
left join dim_date
ON plan_revenue.date = dim_date.date
where month_name IN('Jan','Feb','Mar','Apr') 
group by month_name, plans
order by case when month_name = 'Jan' THEN 1
when month_name = 'Feb' THEN 2
when month_name = 'Mar' THEN 3
when month_name = 'Apr' THEN 4
END

-- plan revenue (in crores) comparison AFTER 5G

SELECT month_name, plans, sum(plan_revenue_crores) AS plan_rev_post5G from plan_revenue
left join dim_date
ON plan_revenue.date = dim_date.date
where month_name IN('Jun','Jul','Aug','Sep')
group by month_name, plans
order by case when month_name = 'Jun' THEN 1
when month_name = 'Jul' THEN 2
when month_name = 'Aug' THEN 3
when month_name = 'Sep' THEN 4
END


-- CITY-WISE METRICS before 5G

SELECT month_name, city_name, 
SUM(atliqo_revenue_crores) AS revenue_crores, 
avg(arpu) as arpu, 
SUM(active_users_lakhs) as active_users_lac, 
SUM(unsubscribed_users_lakhs) as unsub_users_lac from metrics
JOIN dim_cities
ON dim_cities.city_code = metrics.city_code
LEFT JOIN dim_date
ON dim_date.date = metrics.[date]
where month_name IN('Jan','Feb','Mar','Apr') 
group by city_name, month_name

-- CITY-WISE METRICS AFTER 5G

SELECT month_name, city_name, 
SUM(atliqo_revenue_crores) AS revenue_crores, 
avg(arpu) as arpu, 
SUM(active_users_lakhs) as active_users_lac, 
SUM(unsubscribed_users_lakhs) as unsub_users_lac from metrics
JOIN dim_cities
ON dim_cities.city_code = metrics.city_code
LEFT JOIN dim_date
ON dim_date.date = metrics.[date]
where month_name IN('Jun','Jul','Aug','Sep')
group by city_name, month_name


