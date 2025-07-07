-- Customer count by gender and age group
SELECT gender, 
	CASE 
		WHEN age < 25 THEN 'Under 25'
        WHEN age BETWEEN 25 AND 40 THEN '25-40'
        WHEN age BETWEEN 41 AND 60 THEN '41-60'
        ELSE '60+'
	END AS age_group,
    COUNT(*) AS customer_count
FROM customers 
GROUP BY gender, age_group;

-- Customers by city (top 10)
SELECT city, COUNT(*) AS customer_count 
FROM customers 
GROUP BY city
ORDER BY customer_count DESC
LIMIT 10;

-- Account type distribution
SELECT account_type, COUNT(*) AS total_accounts
FROM accounts 
GROUP BY account_type;

-- New accounts by year
SELECT YEAR(open_date) AS year, COUNT(*) AS new_accounts
FROM accounts
GROUP BY YEAR(open_date)
ORDER BY year;

-- Net balance per account
SELECT account_id, SUM(amount) AS balance 
FROM transactions 
GROUP BY account_id
ORDER BY balance DESC;

-- Avg monthly deposits vs withdrawals
SELECT 
	YEAR(date) AS year,
    MONTH(date) AS month,
    transaction_type, 
    AVG(amount) as avg_amount 
FROM transactions 
WHERE transaction_type IN ('deposit', 'withdrawal')
GROUP BY YEAR(date), MONTH(date), transaction_type
ORDER BY year, month;

-- Total transaction amount per customer
SELECT c.customer_id, c.name, SUM(t.amount) as net_total 
FROM customers c
	JOIN accounts a ON c.customer_id = a.customer_id
	JOIN transactions t ON a.account_id = t.account_id
GROUP BY c.customer_id, c.name
ORDER BY net_total DESC;

-- Time between consecutive transactions (lag function)
SELECT 
  account_id, 
  transactions_id, 
  date,
  LAG(date) OVER (PARTITION BY account_id ORDER BY date) AS previous_transaction_date,
  DATEDIFF(date, LAG(date) OVER (PARTITION BY account_id ORDER BY date)) AS days_between 
FROM transactions;

-- Ranking customers by total transaction volume
SELECT customer_id, name, total_amount,
	RANK() OVER (ORDER BY total_amount DESC) AS transaction_rank 
FROM (
	SELECT 
		c.customer_id,
        c.name, 
        SUM(t.amount) AS total_amount 
	FROM customers c 
    JOIN accounts a ON c.customer_id = a.customer_id
    JOIN transactions t ON a.account_id = t.account_id
	GROUP BY c.customer_id, c.name
) ranked;

-- Active customers in the last 30 days
WITH recent_transactions AS (
    SELECT DISTINCT a.customer_id
    FROM transactions t
    JOIN accounts a ON t.account_id = a.account_id
    WHERE t.date >= CURDATE() - INTERVAL 30 DAY
)
SELECT 
    c.customer_id,
    c.name
FROM customers c
JOIN recent_transactions r ON c.customer_id = r.customer_id;

-- Customer balance summary (deposits - withdrawals)
SELECT 
    a.account_id,
    a.customer_id,
    c.name,
    SUM(CASE WHEN transaction_type = 'Deposit' THEN amount ELSE -amount END) AS current_balance
FROM transactions t
JOIN accounts a ON t.account_id = a.account_id
JOIN customers c ON a.customer_id = c.customer_id
GROUP BY a.account_id, a.customer_id;

-- Monthly transaction trend
SELECT 
    DATE_FORMAT(date, '%Y-%m') AS month,
    COUNT(*) AS num_transactions,
    SUM(amount) AS total_amount
FROM transactions
GROUP BY DATE_FORMAT(date, '%Y-%m')
ORDER BY month;

-- First and most recent transaction per customer
SELECT c.customer_id, c.name,
	MIN(t.date) AS first_transaction,
    MAX(t.date) AS last_transaction
FROM customers c 
	JOIN accounts a ON c.customer_id = a.customer_id
    JOIN transactions t ON a.account_id = t.account_id
GROUP BY c.customer_id, c.name;

-- Lifetime Value: Total transaction value per customer
SELECT c.customer_id, c.name,
	SUM(t.amount) AS lifetime_value 
FROM customers c 
	JOIN accounts a ON c.customer_id = a.customer_id
    JOIN transactions t ON a.account_id = t.account_id
GROUP BY c.customer_id, c.name
ORDER BY lifetime_value DESC;

-- Product Type Analysis: Activity by account type
SELECT a.account_type, 
	COUNT(t.transactions_id) AS num_transactions,
    SUM(t.amount) AS total_transacted 
FROM accounts a 
	JOIN transactions t ON a.account_id = t.account_id
GROUP BY a.account_type
ORDER BY total_transacted DESC;
