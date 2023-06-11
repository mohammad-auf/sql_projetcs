
-- Question set - 1 (easy)
select * from album;
select * from employee;

-- Q.1. Who is the senior most employee based on job title? --
select * from employee
order by levels desc
limit 1;

-- Q.2. Which countries have the most Invoices? -- 
select* from invoice;

select billing_country ,count(billing_country) as total_no_bills from invoice
group by billing_country
order by total_no_bills desc;

-- Q3.What are top 3 values of total invoice? --

select total from invoice
order by total desc
limit 3; 

-- Q4. Which city has the best customers? We would like to throw a promotional Music Festival in the city
-- we made the most money. Write a query that returns one city that has the highest sum of invoice totals.
-- Return both the city name & sum of all invoice totals


select * from invoice;

select sum(total) as invoice_total, billing_city
from invoice
group by billing_city
order by invoice_total desc
limit 1;

-- Q5. Who is the best customer? The customer who has spent the most money will be declared the best customer.
-- Write a query that returns the person who has spent the most money

select * from customer;
select * from invoice;

select customer.first_name , last_name ,sum(invoice.total) as total_spend
from customer
left join invoice on customer.customer_id = invoice.customer_id
group by (customer.customer_id)
order by total_spend desc
limit 1;



-- Question set - 2 (moderate)


-- Q6. Write query to return the email, first name, last name, & Genre of all Rock Music listeners.
-- Return your list ordered alphabetically by email starting with A


select * from customer;
select * from invoice;
select * from invoice_line;
select * from track;
select * from genre;


SELECT distinct email,first_name,last_name
from customer
JOIN invoice ON customer.customer_id =invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
where track_id IN(
	select track_id from track
	join genre on track.genre_id = genre.genre_id
	where genre.name like 'Rock'
	
)
order by email;


-- Q7.Let's invite the artists who have written the most rock music in our dataset.
-- Write a query that returns the Artist name and total track count of the top 10 rock bands.

select * from artist;
select * from track;
select * from genre;

select artist.name ,count(artist.name) as total_number_music from artist
join album on artist.artist_id = album.artist_id
join track on album.album_id= track.album_id
join genre on track.genre_id = genre.genre_id
where genre.name like 'Rock'
group by (artist.artist_id)
order by total_number_music desc
limit 10
;



-- Q8. Return all the track names that have a song length longer than the average song length.
-- Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first

select * from track;

select avg(milliseconds) from track;
select name , milliseconds from track where milliseconds >393599.212103910933 order by milliseconds desc ;


-- methode 2 effective query

select name , milliseconds from track
where milliseconds > (
	select avg(milliseconds)
	from track
)
order by milliseconds desc;


-- Question Set 3 – Advance

-- Q8. Find how much amount spent by each customer on artists?
-- Write a query to return customer name, artist name and total spent

select * from customer;
select * from invoice;
select * from invoice_line;

select customer.customer_id,customer.first_name,customer.last_name ,artist.name as artist_name,
sum(invoice_line.unit_price * invoice_line.quantity) as total_spend from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
join track on invoice_line.track_id = track.track_id
join album on track.album_id = album.album_id
join artist on album.artist_id = artist.artist_id 
group by customer.customer_id,customer.first_name,customer.last_name ,artist.name
order by 5 desc;




WITH best_selling_artist AS (
	SELECT artist.artist_id AS artist_id, artist.name AS artist_name, SUM(invoice_line.unit_price*invoice_line.quantity) AS total_sales
	FROM invoice_line
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN album ON album.album_id = track.album_id
	JOIN artist ON artist.artist_id = album.artist_id
	GROUP BY 1
	ORDER BY 3 DESC
)
SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name, SUM(il.unit_price*il.quantity) AS amount_spent
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album alb ON alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC;

-- Q9:- We want to find out the most popular music Genre for each country. 
-- We determine the most popular genre as the genre with the highest amount of purchases. 
-- Write a query that returns each country along with the top Genre. 
-- For countries where the maximum number of purchases is shared return all Genres

select * from genre;
select * from customer;
select * from invoice_line;

with best_genre as  (
select customer.country, count(invoice_line.quantity) as total_no_purchase ,genre.name,genre.genre_id,
ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo
from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
join track on invoice_line.track_id = track.track_id
join genre on genre.genre_id =track.genre_id
group by 1,3,4
order by 1 ,2 desc
)

select * from best_genre where RowNo<=1;


-- Q10. Write a query that determines the customer that has spent the most on music for each country.
-- Write a query that returns the country along with the top customer and how much they spent.
-- For countries where the top amount spent is shared, provide all customers who spent this amount


select * from track;

select composer from track
group by composer;

-- methode 1 all customer 
select * from invoice;
select customer.customer_id ,customer.first_name ,customer.last_name,invoice.billing_country ,sum(invoice.total) as total_spend from customer
join invoice on customer.customer_id = invoice.customer_id
group by 1,2,3,4
order by 4 asc,5 desc;

-- methode 2  for only top customer 
WITH Customter_with_country AS (
		SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending,
	    ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo 
		FROM invoice
		JOIN customer ON customer.customer_id = invoice.customer_id
		GROUP BY 1,2,3,4
		ORDER BY 4 ASC,5 DESC)
SELECT * FROM Customter_with_country WHERE RowNo <= 1;
