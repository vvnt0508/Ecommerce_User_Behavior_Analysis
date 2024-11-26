## Ecommerce_User_Behavior_Analysis
### *Overview: Analyzed e-commerce data to uncover patterns through data cleaning and extraction to address business questions.*
#### Base on a Google Analytics dataset (ga_sessions_2017), this project focuses on analyzing e-commerce data to understand customer behavior and improve business strategies. It uses SQL to extract important information such as customer visits, transactions, and product views. The goal is to track customer interactions, identify patterns in purchases, and measure key metrics like bounce rates and revenue. By analyzing this data, it can helps businesses improve their marketing, sales, and customer retention strategies.
#### This project will answer various questions, such as:
1. **Query 01**: Calculate total visit, pageview, transaction for Jan, Feb and March 2017 (order by month).
2. **Query 02**: Bounce rate per traffic source in July 2017.
- In this query we will use Bounce_rate = num_bounce/total_visit (order by total_visit DESC)
- and we need to note that bounce session is the session that user does not raise any click after landing on the website
3. **Query 03**: Revenue by traffic source by week, by month in June 2017.
- In this query, we will devide productRevenue by 1000000 to shorten the result
- Separate month and week data then union all and use the condition "product.productRevenue is not null" to calculate correctly
4. **Query 04**: Average number of pageviews by purchaser type (purchasers vs non-purchasers) in June, July 2017.
- We will calculate Avg pageview = total pageview / number unique user
- Also notice that purchaser: totals.transactions >=1; productRevenue is not null while non-purchaser: totals.transactions IS NULL;  product.productRevenue is null
5. **Query 05**: Average number of transactions per user that made a purchase in July 2017.
- Notice that we will use the condition "product.productRevenue is not null" to calculate correctly
6. **Query 06**: Average amount of money spent per session. Only include purchaser data in July 2017.
- We need to notice that per visit is different to per visitor
- Avg_spend_per_session = total revenue/ total visit and to shorten the result, productRevenue should be divided by 1000000
7. **Query 07**: Other products purchased by customers who purchased product "YouTube Men's Vintage Henley" in July 2017. Output should show product name and the quantity was ordered.
8. **Query 08**: Calculate cohort map from product view to addtocart to purchase in Jan, Feb and March 2017.
- For example, 100% product view then 40% add_to_cart and 10% purchase
- Notice that Add_to_cart_rate = number product add to cart/number product view, Purchase_rate = number product purchase/number product view
- Hints for this dataset are: hits.eCommerceAction.action_type = '2' is view product page; hits.eCommerceAction.action_type = '3' is add to cart; hits.eCommerceAction.action_type = '6' is purchase
