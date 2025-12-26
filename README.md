# Sales data cleaning in SQL
An end-to-end SQL data cleaning and validation project demonstrating:

  - Column-level data profiling

  - Rule-based data standardisation

  - Cross-table integrity checks

  - Business-aligned data quality validation

applied to a real-world retail sales dataset.

This project is structured as a portfolio-grade SQL case study, emphasising reproducibility, transparency, and analytical trust.

The dataset used in this project was sourced from Kaggle

**Dataset:** Messy Retail Fashion Data

**Platform:** Kaggle

**Link:** https://www.kaggle.com/datasets/vanpatangan/retail-fashion-data

📘**Data Dictionary** 

**Customer Data**
| Column Name | Description | Data Type | Notes |
|------------|-------------|-----------|-------|
| cusomter_id | Unique customer identifier | VARCHAR(7) | Primary key |
| age | Customer age |INT | |
| gender| Gender of cusomter | VARCHAR(6)| Null values can be classified as 'Other'| 
| email | Email address of customer | VARCHAR(255)||


**Product Data**
| Column Name | Description | Data Type | Notes |
|------------|-------------|-----------|-------|
|product_id | Unique product ID | VARCHAR | Primary key |
| category | Type of product | VARCHAR(225)||
|
