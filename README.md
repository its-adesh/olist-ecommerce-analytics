# Olist E-Commerce Analytics | SQL & Power BI

## Project Overview

I used PostgreSQL and Power BI to analyse the Brazilian Olist e-commerce dataset and explore sales performance, customer purchasing behaviour, delivery operations, and customer satisfaction.

I worked with nine related datasets, analysed them using SQL, and built three interactive Power BI dashboard pages to communicate my findings.

## Business Questions

- How did sales performance change over time?
- Which product categories generated the highest sales?
- How often did customers make repeat purchases?
- Which states and product categories experienced more delivery delays?
- How were delivery delays associated with customer review scores?

## Tools & Dataset

- **PostgreSQL and pgAdmin:** Data preparation, relationships, validation, and SQL analysis.
- **Power BI:** Data modelling and interactive dashboards.
- **DAX:** Measures for payment value, customer behaviour, and delivery performance.
- **Power Query:** Data preparation and data type checks.

I used the Brazilian E-Commerce Public Dataset by Olist, available on Kaggle. It contains 99,441 orders, with information about customers, order items, payments, reviews, products, sellers, geolocation, and product category translations.

## My Approach

### 1. Database Setup

I imported nine CSV datasets into PostgreSQL using pgAdmin, configured table relationships, and checked for duplicates, missing values, and consistency.

### 2. SQL Analysis

I analysed payment values, monthly trends, product categories, customer spending, repeat purchases, and delivery performance. I used joins, aggregations, conditional logic, and CTEs to answer the business questions.

I kept payment-level and item-level calculations separate to avoid inflating totals when joining tables with multiple records per order.

### 3. Power BI Dashboards

I connected PostgreSQL to Power BI, reviewed data types and relationships, and created DAX measures. I built three dashboard pages and compared key Power BI calculations with my SQL results.

## Sales Performance

![Sales Performance Dashboard](screenshots/sales_performance.png)

- **Total payment value from delivered orders:** R$15.42 million.
- **Delivered orders:** 96,478.
- **Average payment value per delivered order:** R$159.85.
- November 2017 recorded the highest monthly payment value.
- Health & Beauty was the highest-selling product category among delivered orders.

## Customer Analytics

![Customer Analytics Dashboard](screenshots/customer_analytics.png)

- **Unique customers with delivered orders:** 93,358.
- **Repeat customers:** 2,801.
- **Repeat customer rate:** 3.00%.
- **Average customer review score:** 4.16/5.

Only around 3% of customers with delivered orders made more than one delivered purchase in the observed dataset. This gives a starting point for investigating repeat purchasing and customer engagement.

## Delivery & Operations

![Delivery & Operations Dashboard](screenshots/delivery_operations.png)

- **On-time delivery rate:** 93.23%.
- **Late deliveries:** 6,534.
- **Average delay among late deliveries:** 10.62 days.
- Alagoas had the highest state-level late-delivery rate at **21.41%**.
- Rio de Janeiro had **1,495 late deliveries** and a **12.11% late-delivery rate**.

### Delivery Delays and Customer Satisfaction

| Delivery status | Average review score |
|---|---:|
| On time | 4.29 |
| 1–3 days late | 3.29 |
| 4–7 days late | 2.11 |
| 8–14 days late | 1.67 |
| 15+ days late | 1.73 |

Late deliveries were associated with lower average review scores. Scores generally declined across longer delay groups, although the pattern was not strictly decreasing.

## Business Recommendations

- **Investigate delivery bottlenecks:** Monitor orders approaching their estimated delivery dates and identify regions with recurring delays.
- **Prioritise by rate and volume:** Investigate Rio de Janeiro because it combines an elevated delay rate with a substantial number of affected orders.
- **Test proactive communication:** Provide earlier updates when delays are expected and measure whether this improves the customer experience.
- **Investigate repeat purchasing:** Explore customer engagement and post-purchase experiences, accounting for how long each customer is observed.
- **Monitor satisfaction:** Track review scores alongside delivery performance when evaluating operational changes.

These are recommendations from historical analysis; their business impact would need to be tested.

## Methodology & Limitations

- Payment value and product sales were calculated separately because payments and order items are recorded at different levels.
- I used `customer_unique_id` to identify customers across orders.
- Repeat purchasing was measured among customers with delivered orders within the observed dataset; it is not a complete measure of long-term retention.
- Delivery punctuality was measured by comparing actual and estimated calendar delivery dates.
- An order containing several product categories may contribute to more than one category's delivery statistics.
- Payment value is not necessarily equivalent to recognised business revenue.
- The data describes historical transactions and does not represent current Olist performance.
- Associations between delivery delays and review scores do not establish causation.

## Project Files

My SQL scripts, Power BI report, and dashboard screenshots are available below.

- **SQL — `sql/`:** Table setup, relationships, validation, and sales, customer, and delivery queries.
- **Power BI report:** [Download the .pbix file](https://github.com/its-adesh/olist-ecommerce-analytics/releases/tag/v1.0). Includes Sales Performance, Customer Analytics, and Delivery & Operations. Open it in Power BI Desktop.
- **Screenshots — `screenshots/`:** `sales_performance.png`, `customer_analytics.png`, and `delivery_operations.png`.

The SQL setup scripts are being checked before I describe the project as fully reproducible.

## Conclusion

This project brought together relational data analysis, SQL, data modelling, DAX, and dashboard development. I focused on explaining what the results mean for sales, customer behaviour, and delivery operations, and identifying practical actions a business could test.
