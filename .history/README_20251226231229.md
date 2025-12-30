# Sales Data Cleaning in SQL

An end-to-end SQL data cleaning and validation project demonstrating:

- Column-level data profiling
- Rule-based data standardisation
- Cross-table integrity checks
- Business-aligned data quality validation

applied to a real-world retail sales dataset.

This project is structured as a portfolio-grade SQL case study, emphasising reproducibility, transparency, and analytical trust.

---
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

## 🤵 Customer Data

| Column Name   | Description                    | Data Type     | Notes |
|--------------|--------------------------------|---------------|------|
| customer_id  | Unique customer identifier     | VARCHAR(7)    | Primary key |
| age          | Customer age                   | INT           | |
| gender       | Customer gender                | VARCHAR(6)    | Null values classified as `Other` |
| email        | Customer email address         | VARCHAR(255)  | |

---

## 👕 Product Data

| Column Name   | Description                                   | Data Type      | Notes |
|--------------|-----------------------------------------------|----------------|------|
| product_id   | Unique product ID                             | VARCHAR(225)   | Primary key |
| category     | Type of product                               | VARCHAR(225)   | |
| color        | Color of product                              | VARCHAR(225)   | |
| size         | Size of product                               | VARCHAR(225)   | |
| season       | Season the product is intended for            | VARCHAR(225)   | |
| supplier     | Supplier of the product                       | VARCHAR(225)   | |
| cost_price   | Cost price of the product                     | FLOAT          | |
| list_price   | Listed selling price before any discount      | FLOAT          | |

---

### 🛍️ Store Data

| Column Name     | Description                     | Data Type     | Notes |
|-----------------|---------------------------------|---------------|------|
| store_id        | Unique store ID                 | VARCHAR(225)  | Primary key |
| store_name      | Name of store                   | VARCHAR(225)  | |
| region          | Location of store               | VARCHAR(225)  | |
| store_size_m2   | Size of store in square metres  | INT           | |

---

### 💰 Sales Data

| Column Name     | Description                                   | Data Type      | Notes |
|-----------------|-----------------------------------------------|----------------|------|
| transaction_id  | Unique transaction ID                         | VARCHAR(225)   | Primary key |
| date            | Date of transaction (YYYY-MM-DD)              | DATE           | |
| product_id      | Unique product ID                             | VARCHAR(225)   | Foreign key |
| store_id        | Unique store ID                               | VARCHAR(225)   | Foreign key |
| customer_id     | Unique customer ID                            | VARCHAR(225)   | Foreign key |
| quantity        | Quantity of items purchased                   | INT            | |
| discount        | Discount applied to original price            | FLOAT          | |
| returned        | Quantity of items returned                    | INT            | |

---

## 🧪 Data Quality Rules

The following data quality rules were applied consistently across the dataset:

- Primary keys must be non-null and unique
- Foreign key values must exist in parent tables
- Mandatory fields must be populated
- Numerical values must fall within realistic ranges
- No silent corrections of anomalous values

