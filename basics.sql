use bank;
select * from trans;
select * from bank.trans;
select * from district;
select * from card;
select * from bank.account;
select * from bank.client;
select * from disp;
select * from loan;
select * from bank.order;



-- Get the id values of the first 5 clients from district_id with a value equals to 1
select client_id
from bank.client 
where district_id = 1
limit 5;



-- In the client table, get an id value of the last client where the district_id equals to 72 
select client_id from bank.client
where district_id=72;



-- Get the 3 lowest amounts in the loan table

select amount
from loan 
order by amount asc
limit 3;


-- What are the possible values for status, ordered alphabetically in ascending order in the loan table?

select loan.status 
from loan 
order by loan.status asc;


-- What is the loan_id of the highest payment received in the loan table?
select loan_id
from loan 
order by payments desc
limit 1;

-- What is the loan amount of the lowest 5 account_ids in the loan table? Show the account_id and the corresponding amount
select account_id, amount
from loan 
order by account_id asc
limit 5;


-- What are the account_ids with the lowest loan amount that have a loan duration of 60 in the loan table?
select account_id, amount
from loan
where duration = 60 order by amount asc;

-- What are the unique values of k_symbol in the order table?
select distinct(k_symbol) from `order`;

-- In the order table, what are the order_ids of the client with the account_id 34?
select order_id from `order` where account_id = 34;

-- In the order table, which account_ids were responsible for orders between order_id 29540 and order_id 29560 (inclusive)?
select distinct(account_id) from `order` where order_id between 29540 and 29560;

-- In the order table, what are the individual amounts that were sent to (account_to) id 30067122?
select amount from `order` where account_to = 30067122;

-- In the trans table, show the trans_id, date, type and amount of the 10 first transactions from account_id 793 in chronological order, from newest to oldest.
select trans_id, `date`, `type`, amount from trans where account_id = 793 order by date desc limit 10;


-- In the client table, of all districts with a district_id lower than 10, how many clients are from each district_id? Show the results sorted by the district_id in ascending order.
select district_id, count(client_id) from client
where district_id < 10
group by district_id
order by district_id asc;

-- In the card table, how many cards exist for each type? Rank the result starting with the most frequent type.
select `type`, count(card_id) from card
group by `type`
order by count(`type`) desc;

-- Using the loan table, print the top 10 account_ids based on the sum of all of their loan amounts.
select account_id, sum(amount) from loan
group by account_id
order by sum(amount) desc limit 10;

-- In the loan table, retrieve the number of loans issued for each day, before (excl) 930907, ordered by date in descending order.
select convert(date,date), count(loan_id) from loan
where convert(date,date) < '1993-09-07'
group by convert(date,date)
order by convert(date,date) desc;

-- In the loan table, for each day in December 1997, count the number of loans issued for each unique loan duration, ordered by date and duration, both in ascending order. You can ignore days without any loans in your output.
select convert(date,date), duration, count(loan_id) from loan
where convert(date,date) between '1997-12-01' and '1998-01-01'
group by convert(date,date), duration
order by convert(date,date) asc, duration asc;

-- In the trans table, for account_id 396, sum the amount of transactions for each type (VYDAJ = Outgoing, PRIJEM = Incoming). Your output should have the account_id, the type and the sum of amount, named as total_amount. Sort alphabetically by type.
select account_id, type, sum(amount) as total_amount from trans
where account_id = '396'
group by account_id, type
order by type asc, sum(amount) asc;

--  From the previous output, translate the values for type to English, rename the column to transaction_type, round total_amount down to an integer
SELECT temp_table.account_id,
    CASE
        WHEN temp_table.type = 'PRIJEM' THEN 'Incoming'
        WHEN temp_table.type = 'VYDAJ' THEN 'Outgoing'
    END AS transaction_type,
    FLOOR(temp_table.total_amount)
FROM
    (SELECT 
        account_id, type, SUM(amount) AS total_amount
    FROM
        trans
    WHERE
        account_id = '396'
    GROUP BY account_id , type
    ORDER BY type ASC , SUM(amount) ASC) AS temp_table;
    
    
-- From the previous result, modify your query so that it returns only one row, with a column for incoming amount, outgoing amount and the difference.
SELECT 
    account_id,
    FLOOR(SUM(CASE
                WHEN type = 'PRIJEM' THEN amount
            END)) AS incoming,
    FLOOR(SUM(CASE
                WHEN type = 'VYDAJ' THEN amount
            END)) AS Outgoing,
    FLOOR(SUM(CASE
                WHEN type = 'PRIJEM' THEN amount
                WHEN type = 'VYDAJ' THEN - amount
            END)) as difference
FROM
    trans
WHERE
    account_id = '396';


-- Continuing with the previous example, rank the top 10 account_ids based on their difference.
select account_id, FLOOR(SUM(CASE WHEN type = 'PRIJEM' THEN amount WHEN type = 'VYDAJ' THEN - amount END)) as difference from trans
group by account_id
order by difference desc limit 10;