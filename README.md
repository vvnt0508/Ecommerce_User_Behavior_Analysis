## [SQL] Ecommerce User Behavior Analysis

### 1. Introduction: Analyzed e-commerce data to identify patterns through data cleaning and extraction, addressing key business questions.
- This project utilizes SQL on [Google BigQuery](https://cloud.google.com/bigquery/docs/introduction) platform to extract important informations.
- Why? [Google BigQuery Public Datasets](https://cloud.google.com/bigquery/?utm_source=google&utm_medium=cpc&utm_campaign=japac-VN-all-en-dr-BKWS-all-all-trial-EXA-dr-1605216&utm_content=text-ad-none-none-DEV_c-CRE_658171082826-ADGP_Hybrid+%7C+BKWS+-+BRO+%7C+Txt+-Data+Analytics-BigQuery-big+query-main-KWID_43700081106765487-kwd-35927591586&userloc_9208070-network_g&utm_term=KW_big+query&gad_source=1&gclid=Cj0KCQiA4fi7BhC5ARIsAEV1YiZiQMgikH8ALUJUgZa8GtwebyKj7voccMDJVta19CbI64gT-bMQVQAaAnWPEALw_wcB&gclsrc=aw.ds&hl=en) are free, large datasets provided by Google, covering various fields like finance, healthcare, science, society, and technology. Base on a public dataset (ga_sessions_2017), this project focuses on analyzing e-commerce data to understand customer behavior and improve business strategies.

### 2. This project will answer various questions, such as:
**Query 01: Calculate total visit, pageview, transaction for Jan, Feb and March 2017 (order by month)**
- SQL code
  
![q1](https://i.imgur.com/dRrR6cT.png)

- Result

![rs](https://i.imgur.com/AKp2d3z.png)

**Query 02: Bounce rate per traffic source in July 2017.**
- Bounce session is the session that user does not raise any click after landing on the website
- SQL code

![q2](https://i.imgur.com/2Sjh3Hx.png)

- Result

![rs](https://i.imgur.com/QtKC9tO.png)

**Query 03: Revenue by traffic source by week, by month in June 2017.**
- SQL code

![q3](https://i.imgur.com/O94nUmb.png)

- Result

![rs](https://i.imgur.com/39tjTFu.png)

**Query 04: Average number of pageviews by purchaser type (purchasers vs non-purchasers) in June, July 2017.**
- We will calculate Avg pageview = total pageview / number unique user
- purchaser: totals.transactions >=1; productRevenue is not null; non-purchaser: totals.transactions IS NULL.

- SQL code

![q4](https://i.imgur.com/NIReDYO.png)

- Result

![rs](https://i.imgur.com/POCJp0J.png)

**Query 05: Average number of transactions per user that made a purchase in July 2017.**
- SQL code

![q5](https://i.imgur.com/K4jGR7P.png)

- Result
  
![rs](https://i.imgur.com/6QROTHn.png)

**Query 06: Average amount of money spent per session. Only include purchaser data in July 2017.**
- Per visit is different to per visitor
- SQL code

![q6](https://i.imgur.com/ZAkMUIO.png)

- Result

![rs](https://i.imgur.com/3zZnSlQ.png)

**Query 07: Other products purchased by customers who purchased product "YouTube Men's Vintage Henley" in July 2017. Output should show product name and the quantity was ordered.**
- SQL code

![q7](https://i.imgur.com/GjQVylq.png)

- Result

![rs](https://i.imgur.com/J4zx9AA.png)

**Query 08: Calculate cohort map from product view to addtocart to purchase in Jan, Feb and March 2017.**
- For example, 100% product view then 40% add_to_cart and 10% purchase
- hits.eCommerceAction.action_type = '2' is view product page; hits.eCommerceAction.action_type = '3' is add to cart; hits.eCommerceAction.action_type = '6' is purchase
- SQL code

![q8](

- Result

![rs](https://i.imgur.com/aLsbm3h.png)
