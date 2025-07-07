# Banking Customer SQL Analysis

This SQL project explores a simulated banking dataset with a focus on analyzing customer demographics, account activity, transaction trends, and customer value.

---

## Project Overview

This project was created to showcase SQL skills relevant to a data analyst role, including:

- Schema design for banking entities (customers, accounts, transactions)  
- Business-driven SQL queries for customer and transaction insights  
- Window functions for advanced analytics  
- Views for modular, reusable reporting  

The dataset is AI-generated and represents a bank’s operations with multiple account types and transaction records.

---

## Database Structure

The project is structured around 3 core tables:

- customers  
- accounts  
- transactions  

All tables are connected with proper primary and foreign keys to simulate realistic business data relationships.

---

## Key Business Questions Answered

Some examples of questions this project answers:

- What is the customer distribution by age and gender?  
- Which cities have the most customers?  
- How do account types distribute and grow over time?  
- What are the net balances and lifetime values per customer?  
- Which customers have the highest transaction volumes and frequency?  
- How do monthly transaction trends evolve?  
- What is the average time between transactions per account?  

---

## SQL Techniques Used

- JOINs for multi-table analysis  
- Aggregate Functions (SUM, AVG, COUNT)  
- Window Functions (RANK, LAG)  
- CASE WHEN for conditional categorization  
- Views for reusable reporting layers  
- Date filtering with CURDATE() and intervals  

---

## Example Query

```sql
SELECT customer_id,
       SUM(amount) AS total_transaction_amount,
       RANK() OVER (ORDER BY SUM(amount) DESC) AS transaction_rank
FROM transactions
GROUP BY customer_id;
