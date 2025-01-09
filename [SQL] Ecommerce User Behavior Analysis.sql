--Query 01: calculate total visit, pageview, transaction for Jan, Feb and March 2017 (order by month)

SELECT 
        FORMAT_DATE('%Y%m', PARSE_DATE('%Y%m%d', date)) as month
        ,SUM (totals.visits) visits
        ,SUM (totals.pageviews) pageviews
        ,SUM (totals.transactions) transactions
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
where _table_suffix between '0101'and '0331'
group by 1
order by month ASC;

--Query 02: Bounce rate per traffic source in July 2017

SELECT 
      trafficSource.`source`
      ,count (totals.visits) total_visits
      ,count (totals.bounces) total_no_of_bounces
      ,round(count(totals.bounces)/count(totals.visits)*100,3) bounce_rate

FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
group by 1
order by total_visits DESC;

--Query 03: Revenue by traffic source by week, by month in June 2017

with 
month_data as 
      (SELECT
            'month'as time_type,
            FORMAT_DATE("%Y%m",PARSE_DATE('%Y%m%d',date)) as time
            ,trafficSource.`source` as source
            ,SUM (product.productRevenue)/1000000 as revenue,

      FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201706*`,
            UNNEST (hits) hits,
            UNNEST (hits.product) product
      WHERE product.productRevenue is not null
      group by time,source)

,week_data as
      (SELECT
            'week'as time_type,
            FORMAT_DATE("%Y%W",PARSE_DATE('%Y%m%d',date)) as time
            ,trafficSource.`source` as source
            ,SUM (product.productRevenue)/1000000 as revenue,

      FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201706*`,
            UNNEST (hits) hits,
            UNNEST (hits.product) product
      WHERE product.productRevenue is not null
      group by time,source)

SELECT * from month_data
union all
select * from week_data
order by revenue DESC;

--Query 04: Average number of pageviews by purchaser type (purchasers vs non-purchasers) in June, July 2017. Note: purchaser: totals.transactions >=1; productRevenue is not null; non-purchaser: totals.transactions IS NULL

with
purchaser_data as(
      SELECT
            FORMAT_DATE ("%Y%m",parse_date("%Y%m%d",date)) as month,
            (SUM(totals.pageviews)/COUNT(distinct fullvisitorid)) as avg_pageviews_purchase,
      FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
            ,UNNEST(hits) hits
            ,UNNEST(product) product
      WHERE _table_suffix between '0601' and '0731'
      and totals.transactions>=1
      and product.productRevenue is not null
      group by month
),

non_purchaser_data as(
      SELECT
            FORMAT_DATE("%Y%m",parse_date("%Y%m%d",date)) as month,
            SUM(totals.pageviews)/count(distinct fullvisitorid) as avg_pageviews_non_purchase,
      FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
            ,UNNEST(hits) hits
            ,UNNEST(product) product
      WHERE _table_suffix between '0601' and '0731'
      and totals.transactions is null
      and product.productRevenue is null
      group by month
)

SELECT
    pd.*,
    avg_pageviews_non_purchase
FROM purchaser_data pd
FULL JOIN non_purchaser_data using(month)
order by pd.month;

--Query 05: Average number of transactions per user that made a purchase in July 2017

SELECT 
      FORMAT_DATE('%Y%m',PARSE_DATE('%Y%m%d',date)) as month
      ,round(sum(totals.transactions) / count(distinct fullVisitorId), 9) as avg_total_transactions_per_user
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`,
      UNNEST(hits) hits,
      UNNEST(hits.product) product
WHERE _table_suffix BETWEEN '01'AND '31'and product.productRevenue is not null
group by month;

--Query 06: Average amount of money spent per session. Only include purchaser data in July 2017

SELECT 
      FORMAT_DATE('%Y%m', PARSE_DATE('%Y%m%d', date)) AS month,
      ROUND(SUM(product.productRevenue) / 1000000 / COUNT(*), 2) AS avg_spend_per_session
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`,
      UNNEST(hits) AS hits,
      UNNEST(hits.product) AS product
WHERE _table_suffix BETWEEN '01' AND '31'
      AND totals.transactions is not null
      AND product.productRevenue is not null
GROUP BY month;

--Query 07: Other products purchased by customers who purchased product "YouTube Men's Vintage Henley" in July 2017. Output should show product name and the quantity was ordered.

with buyer_list as(
      SELECT
            distinct fullVisitorId
      FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
      , UNNEST(hits) AS hits
      , UNNEST(hits.product) as product
      WHERE product.v2ProductName = "YouTube Men's Vintage Henley"
      AND totals.transactions>=1
      AND product.productRevenue is not null
)

SELECT
      product.v2ProductName AS other_purchased_products,
      SUM(product.productQuantity) AS quantity
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
, UNNEST(hits) AS hits
, UNNEST(hits.product) as product
JOIN buyer_list using(fullVisitorId)
WHERE product.v2ProductName != "YouTube Men's Vintage Henley"
      and product.productRevenue is not null
GROUP BY other_purchased_products
ORDER BY quantity DESC;

--"Query 08: Calculate cohort map from product view to addtocart to purchase in Jan, Feb and March 2017. For example, 100% product view then 40% add_to_cart and 10% purchase.

with
product_view as(
      SELECT
            format_date("%Y%m", parse_date("%Y%m%d", date)) as month,
            count(product.productSKU) as num_product_view
      FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
      ,UNNEST(hits) AS hits
      ,UNNEST(hits.product) as product
      WHERE _TABLE_SUFFIX BETWEEN '20170101' AND '20170331'
      AND hits.eCommerceAction.action_type = '2'
      GROUP BY 1
),

add_to_cart as(
      SELECT
            format_date("%Y%m", parse_date("%Y%m%d", date)) as month,
            count(product.productSKU) as num_addtocart
      FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
      ,UNNEST(hits) AS hits
      ,UNNEST(hits.product) as product
      WHERE _TABLE_SUFFIX BETWEEN '20170101' AND '20170331'
      AND hits.eCommerceAction.action_type = '3'
      GROUP BY 1
),

purchase as(
      SELECT
            format_date("%Y%m", parse_date("%Y%m%d", date)) as month,
            count(product.productSKU) as num_purchase
      FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
      ,UNNEST(hits) AS hits
      ,UNNEST(hits.product) as product
      WHERE _TABLE_SUFFIX BETWEEN '20170101' AND '20170331'
      AND hits.eCommerceAction.action_type = '6'
      and product.productRevenue is not null
      GROUP BY 1
)

select
    pv.*,
    num_addtocart,
    num_purchase,
    round(num_addtocart*100/num_product_view,2) as add_to_cart_rate,
    round(num_purchase*100/num_product_view,2) as purchase_rate
from product_view pv
left join add_to_cart a on pv.month = a.month
left join purchase p on pv.month = p.month
order by pv.month
),

purchase as(
      SELECT
            format_date("%Y%m", parse_date("%Y%m%d", date)) as month,
            count(product.productSKU) as num_purchase
      FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
      ,UNNEST(hits) AS hits
      ,UNNEST(hits.product) as product
      WHERE _TABLE_SUFFIX BETWEEN '20170101' AND '20170331'
      AND hits.eCommerceAction.action_type = '6'
      and product.productRevenue is not null
      GROUP BY 1
)

select
    pv.*,
    num_addtocart,
    num_purchase,
    round(num_addtocart*100/num_product_view,2) as add_to_cart_rate,
    round(num_purchase*100/num_product_view,2) as purchase_rate
from product_view pv
left join add_to_cart a on pv.month = a.month
left join purchase p on pv.month = p.month
order by pv.month