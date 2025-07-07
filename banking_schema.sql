CREATE DATABASE banking_portfolio;
USE banking_portfolio;

CREATE TABLE customers
(
	customer_id INT PRIMARY KEY,
	name VARCHAR (100),
    age INT,
    gender VARCHAR (10),
    city VARCHAR (100),
    signup_date DATE
);

CREATE TABLE accounts
(
	account_id INT PRIMARY KEY,	
    customer_id INT, 
    account_type VARCHAR(20),
    open_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE transactions 
(
	transactions_id INT PRIMARY KEY,
    account_id INT,
    amount DECIMAL (10,2),
    transaction_type VARCHAR (20),
    date DATE,
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);
