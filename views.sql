CREATE VIEW top_cities_customers AS
SELECT city, COUNT(*) AS customer_count
FROM customers
GROUP BY city
ORDER BY customer_count DESC;

CREATE VIEW account_type_distribution AS
SELECT account_type, COUNT(*) AS total_accounts
FROM accounts
GROUP BY account_type;

CREATE VIEW account_balances AS
SELECT account_id, SUM(amount) AS balance
FROM transactions
GROUP BY account_id;

CREATE VIEW customer_total_transactions AS
SELECT 
    c.customer_id, 
    c.name, 
    SUM(t.amount) AS net_total
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
JOIN transactions t ON a.account_id = t.account_id
GROUP BY c.customer_id, c.name;

CREATE VIEW customer_lifetime_value AS
SELECT 
    c.customer_id,
    c.name,
    SUM(t.amount) AS lifetime_value
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
JOIN transactions t ON a.account_id = t.account_id
GROUP BY c.customer_id, c.name
ORDER BY lifetime_value DESC;

CREATE VIEW account_current_balance AS
SELECT 
    a.account_id,
    a.customer_id,
    c.name,
    SUM(CASE WHEN LOWER(transaction_type) = 'deposit' THEN amount ELSE -amount END) AS current_balance
FROM transactions t
JOIN accounts a ON t.account_id = a.account_id
JOIN customers c ON a.customer_id = c.customer_id
GROUP BY a.account_id, a.customer_id, c.name;
