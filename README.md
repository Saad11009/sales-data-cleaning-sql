# Sales Data Cleaning in SQL

An end-to-end SQL data cleaning and validation project demonstrating:

- Column-level data profiling
- Rule-based data standardisation
- Cross-table integrity checks
- Business-aligned data quality validation

applied to a real-world retail sales dataset.

This project is structured as a portfolio-grade SQL case study, emphasising reproducibility, transparency, and analytical trust.

---

## 📊 Dataset Information

The dataset used in this project was sourced from Kaggle.

- **Dataset:** Messy Retail Fashion Data  
- **Platform:** Kaggle  
- **Link:** https://www.kaggle.com/datasets/vanpatangan/retail-fashion-data  

---

## 📘 Data Dictionary

### 🤵 Customer Data

| Column Name   | Description                    | Data Type     | Notes |
|--------------|--------------------------------|---------------|------|
| customer_id  | Unique customer identifier     | VARCHAR(7)    | Primary key |
| age          | Customer age                   | INT           | |
| gender       | Customer gender                | VARCHAR(6)    | Null values classified as `Other` |
| email        | Customer email address         | VARCHAR(255)  | |

---

### 👕 Product Data

| Column Name   | Description                                   | Data Type      | Notes |
|--------------|-----------------------------------------------|----------------|------|
| product_id   | Unique product ID                             | VARCHAR        | Primary key |
| category     | Type of product                               | VARCHAR(225)   | |
| color        | Color of product                              | VARCHAR(225)   | |
| size         | Size of product                               | VARCHAR(225)   | |
| season       | Season the product is intended for            | VARCHAR(225)   | |
| supplier     | Supplier of the product                       | VARCHAR(225)   | |
| cost_price   | Cost price of the product                     | FLOAT          | |
| list_price   | Listed selling price before any discount      | FLOAT          | |

