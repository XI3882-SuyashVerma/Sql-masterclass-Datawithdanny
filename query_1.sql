--------------------------------------For Members data exploration--------------------------------------------

--Question 1 - Show only the top 5 rows from the trading.members table
SELECT *
FROM trading.members
LIMIT 5

--Question 2 - Sort all the rows in the table by first_name in alphabetical order and show the top 3 rows
SELECT TOP 3
FROM trading.members
ORDER by first_name 

--Question 3 - Which records from trading.members are from the United States region?
SELECT * 
FROM trading.members
where region = 'United States'

--Question 4 - Select only the member_id and first_name columns for members who are not from Australia
SELECT member_id,first_name
FROM trading.members
where region <> 'Australia'

--Question 5 - Return the unique region values from the trading.members table and sort the output by reverse alphabetical order
SELECT DISTINCT region
FROM trading.members
ORDER BY region DESC

--Question 6 - How many mentors are not from Australia or the United States?
SELECT COUNT(*) as count_mentor
FROM trading.members
where region NOT in ('Australia', 'United States')

--Question 7 - How many mentors are there per region? Sort the output by regions with the most mentors to the least
SELECT region, count(region) as total_mentors
FROM trading.members
GROUP BY region
ORDER BY total_mentors DESC

--Question 8 - How many US mentors and non US mentors are there?
SELECT 
    CASE 
        WHEN region <> 'United states' THEN 'Non US'
        ELSE region
    END as mentor_region,
    COUNT(mentor_region) as mentor_count  --if this query not works then use COUNT(*)
FROM trading.members
GROUP BY mentor_region

--Question 9 - How many mentors have a first name starting with a letter before 'E'
SELECT COUNT(*) as mentor_count
FROM trading.members
WHERE LEFT(first_name,1) < 'E'

------------------------------For Prices Data analysis-------------------------------------------------------------

--Question 1 - How many records are there per ticker value?
SELECT ticker,COUNT(ticker) as record_count
FROM trading.values
GROUP BY ticker

--Question 2 - differences in the minimum and maximum market_date values for each ticker?
SELECT ticker, min(market_date) as minimum_date, max(market_date) as maximum_date
FROM trading.value
GROUP BY ticker

--Question 3 - average of the price column for Bitcoin records during the year 2020?
SELECT avg(price) as avg_price
FROM trading.value
where ticker = 'BTH' AND market_date BETWEEN '2020-01-01' AND '2020-12-31'

--Question 4 - Are there any duplicate market_date values for any ticker value in our table?
SELECT ticker,
count(market_date) as total_count,
count(DISTINCT market_date) as DISTINCT_total_count
FROM trading.value
GROUP BY ticker

--Question 5 - How many days from the trading.prices table exist where the high price of Bitcoin is over $30,000?
select COUNT(*) as row_count
FROM trading.value
WHERE ticker = 'BTH' AND high > 30000

--Question 6- How many "breakout" days were there in 2020 where the price column is greater than the open column for each ticker?
SELECT ticker,
sum(CASE WHEN price > open THEN 1 ELSE 0 END) as brekout_days
FROM trading.value
WHERE date_trunc('YEAR', market_date) = '2020-01-01' -- we can use as question 7 also
GROUP BY ticker

--Question 7 - How many 'Non - breakout' days were there in 2020 where the price column is less than the open column for each ticker?
SELECT ticker,
sum(CASE WHEN price < open THEN 1 ELSE 1 END) as non_breakout_days
FROM trading.value
WHERE market_date >= '2020-01-01' AND market_date <= '2020-12-31'
GROUP BY ticker

----------------------------Transaction Data----------------------------------------------

--Question 1 - How many buy and sell transactions are there for Bitcoin?
select Txn_Type,
count(*) as TRANSACTION_Count
FROM trading.transaction
where ticker = 'BTC'
GROUP BY Txn_Type

--Question 2 --Calc. 
-- total transaction count
--total quantity
--average quantity per transaction
SELECT 
EXTRACT(YEAR from txn_date) as txn_year,
txn_type,
count(*) as transaction_count,
ROUND(SUM(quantity)::INT,2) as total_quantity,
ROUND(AVG(quantity)::INT,2) as avg_quantity
FROM trading.transaction
GROUP BY txn_date,txn_type

--Question 3 What was the monthly total quantity BUY and SELL for Ethereum in 2020?
--can we use group by txn_type instead of using case statement

SELECT 
date_trunc('MON', txn_date)::DATE as calender_month,
SUM(CASE WHEN txn_type = 'BUY' THEN 1 ELSE 0 END) as buying_quantity,
SUM(CASE where txn_type = 'SELL' then 1 ELSE 0 END) as selling_quantity
FROM trading.transaction
where txn_date BETWEEN '2020-01-01' AND '2020-12-31' AND ticker = 'ETH'--How to add ethereum in this
GROUP BY calender_month
ORDER BY calender_month

--Question 4 
--Bitcoin buy quantity
--Bitcoin sell quantity
--Ethereum buy quantity
--Ethereum sell quantity

--can we do it with group by statements? 
--WHY quantity we can use 1 ?
SELECT member_id,
SUM(CASE WHEN ticker = 'BTC' AND txn_type = 'BUY' THEN quantity ELSE 0 END) as btc_buying_quantity,
SUM(CASE WHEN ticker = 'BTC' AND txn_type = 'SELL' THEN quantity ELSE 0 END) as btc_selling_quantity,
SUM(CASE WHEN ticker = 'ETH' AND txn_type = 'BUY' THEN quantity ELSE 0 END) as ETH_buying_quantity,
SUM(CASE WHEN ticker = 'ETH' AND txn_type = 'SELL' THEN quantity ELSE 0 END) as ETH_selling_quantity
FROM trading.transaction
GROUP BY member_id

--Question 5 Holding quantity in bitcoin

select member_id,
SUM(
    case 
        when txn_type = 'BUY' THEN quantity 
        WHEN Txn_Type = 'SELL' THEN -quantity 
        ELSE 0
    END
    ) as holding_quantity
FROM trading.transaction
WHERE ticker = 'BTC'
GROUP BY member_id
ORDER BY holding_quantity DESC


--Question 6 - Total BTC hold of each member and sorted DESC
SELECT member_id,
SUM(
    CASE
        WHEN txn_type = 'BUY' THEN quantity 
        WHEN txn_type ='SELL' THEN -quantity
        ELSE 0
    END
    ) as total_btc_hold
FROM trading.transaction
WHERE ticker = 'BTC'
GROUP BY member_id
ORDER by total_btc_hold DESC

--Question 7 - member_id has highest buy to sell ratio
SELECT member_id,
SUM(CASE WHEN txn_type = 'BUY' THEN quantity ELSE 0 END) /
SUM(CASE WHEN txn_type = 'SELL' THEN quantity ELSE 0 END) as Buy_sell_ratio
FROM trading.transaction
GROUP BY member_id
ORDER BY Buy_sell_ratio DESC



