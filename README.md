# Business_Case_Mysql
SQL analysis of Magist data to evaluate Eniac’s entry into the Brazilian market


---

# Eniac Brazil Market Expansion Analysis

## Project Overview

Eniac is a Spain-founded online marketplace specializing in Apple products and curated premium accessories, distinguished by its personalized and human-centered tech support. Following its IPO, the company faces strong investor pressure to scale globally while preserving its customer-first identity.

To support this growth, a Data Department was created to strengthen data infrastructure and enable data-driven decision-making. The team includes a Head of Data, a Data Scientist building a recommender system, and a Data Analyst bridging data and business.

This project focuses on evaluating whether Eniac should enter the Brazilian market by analyzing the **Magist dataset using SQL**, with the goal of supporting strategic, data-driven decisions.

---

## Dataset & Sources

**Source**: Magist Brazilian eCommerce Public Dataset (Olist) – available on Kaggle

**Size**: ~100,000 orders, 9 main tables, 30+ features, covering the period from 2016 to 2018

### Key Features:

* order_id, customer_id, order_status
* order_purchase_timestamp, order_delivered_customer_date
* price, freight_value
* product_category_name
* payment_type, payment_value
* customer_state

### Notes:

* Data stored across multiple relational tables (required SQL joins)
* Missing values in delivery dates for canceled or unavailable orders
* Product categories translated from Portuguese
* Outliers in delivery time and freight costs handled
* Time-based data converted to datetime format

---

## Key Findings & Results

* **Strong overall market, weak premium segment**: While Magist generated €13.6M total revenue (2016–2018), the Tech segment contributed only €1.6M
* **Significant price mismatch**: Eniac’s average item price is €540 vs. €102 on Magist
* **Reliable logistics**: Average delivery time is 12.5 days vs. 23.4 days estimated
* **Limited premium scalability**: Only 444 tech sellers and ~15K products sold
* **High external risks**: Economic instability, currency fluctuation, and low purchasing power

---

## Business Impact

Brazil is a **large and attractive long-term market**, but current conditions make immediate expansion risky.

A delayed entry allows Eniac to:

* Preserve capital
* Protect brand positioning
* Monitor market recovery
* Enter at a more favorable time

---

## Technologies Used

**Programming:**

* SQL (MySQL Workbench)

**Tools:**

* SQL environment for querying and aggregation
* Spreadsheet tools for analysis and visualization

**Approach:**

* Relational data analysis (joins, aggregations, filtering, grouping)
* Exploratory data analysis (EDA)
* Business-focused insights from structured data

---

## 📁 Project Structure

* SQL queries used in analysis
* Final presentation slides
* Dataset files (if included)

---

## How to Use This Project

### 1. Data Setup

* Import all dataset tables into your SQL environment

### 2. Run Analysis

* Open SQL Workbench (or any SQL tool)
* Run queries from the sql folder step by step

### 3. Explore Results

* Analyze outputs directly in SQL
* Export results for visualization if needed

### 4. Recreate Insights

* Use Excel or similar tools to recreate charts
* Match findings with the presentation

---

## Future Work

* Deeper analysis of premium tech segments
* Scalability evaluation of Magist logistics
* Monitoring macroeconomic indicators
* Competitive benchmarking with other markets
* Scenario planning (enter now vs. later)

---

## Conclusion

Brazil is the **right market, but the wrong timing**.

The opportunity is strong, but risks outweigh short-term benefits.
A strategic delay is the most effective approach.

---

## Contact

**Email:** [khadijabarkaoui27@gmail.com](mailto:khadijabarkaoui27@gmail.com)
**LinkedIn:** [Khadija Barkaoui](https://www.linkedin.com/in/khadija-barkaoui-a48b86229/)

---

