use  `awesome chocolates`;
-- INTERMEDIATE PROBLEMS 

-- Q1. Print details of shipments (sales) where amounts are > 2,000 and boxes are <100?

select * from sales;
select * from geo;

select s.amount ,s.boxes ,g.geo, g.region
from sales s
join geo g on s.geoid =g.geoid
where s.amount > 2000 and s.boxes < 100
order by 2;  

-- Q2. How many shipments (sales) each of the sales persons had in the month of January 2022?

SELECT salesperson, COUNT(salesperson) AS shipment_count
FROM people p
join sales s on p.spid =s.spid
WHERE MONTH(s.saleDate) = 1 AND YEAR(s.saleDate) = 2022
GROUP BY salesperson;

-- Q3. Which product sells more boxes? Milk Bars or Eclairs?
select * from products;
select * from sales;

select s.pid, pd.product ,sum(s.boxes) from sales s
join products pd on s.pid = pd.pid
where pd.product in ('Milk Bars','Eclairs')
group by 1,2
order by 3 desc
;

-- Q4. Which product sold more boxes in the first 7 days of February 2022? Milk Bars or Eclairs?


select s.pid, pd.product ,sum(s.boxes) as total_no_box_sale
from sales s 
join products pd on s.pid = pd.pid
where date(s.saleDate) >='2022-02-01' and date(s.saleDate) >='2022-02-07' and pd.product in ('Milk Bars','Eclairs')
group by 1,2
order by 3 desc
;

-- Q5. Which shipments had under 100 customers & under 100 boxes? Did any of them occur on Wednesday?
select * from sales;

select s.pid,pd.product,s.saleDate,s.customers , s.boxes
from sales s
join products pd on s.pid = pd.pid
where day(s.saleDate)=3 and s.customers <100 and s.boxes < 100
order by 3,4 ;

-- HARD PROBLEMS

-- Q1. What are the names of salespersons who had at least one shipment (sale) in the first 7 days of January 2022?

select s.spid ,salesperson from people p
join sales s on p.spid =s .spid 
where date(saleDate)>='2022-01-01' and date(saleDate) >='2022-02-07'
group by 1,2
order by 1
;


-- Q2. Which salespersons did not make any shipments in the first 7 days of January 2022?

select * from people;

SELECT p.spid ,p.salesperson
FROM people p
WHERE p.spid NOT IN (
    SELECT s.spid
    FROM sales s
    WHERE s.saleDate >= '2022-01-01' AND s.saleDate <= '2022-01-07'
);

-- Q3. How many times we shipped more than 1,000 boxes in each month?

select monthname(s.saleDate) as months ,count(*) as no_of_times from sales s
where s.boxes > 1000 
group by 1;
;


-- Q4. Did we ship at least one box of ‘After Nines’ to ‘New Zealand’ on all the months?

select * from geo;

select monthname(s.saleDate) as months,count(*)as no_of_times from sales s
join products p on s.pid = p.pid
join geo g on s.geoid = g.geoid
where s.boxes > 1 and p.product like 'After Nines' and g.geo = 'new zealand'
group by 1;
;

-- Q-- 5. India or Australia? Who buys more chocolate boxes on a monthly basis?

select monthname(s.saleDate) as months ,g.geo,count(*)as total_boxes  from sales s
join products p on s.pid = p.pid
join geo g on s.geoid = g.geoid
where g.geo = 'australia' or g.geo = 'india'
group by 1,2 ;