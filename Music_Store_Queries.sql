Q.1.Who is the senior most employee based on job title?
Ans.
select *
from employee
order by levels DESC
limit 1;

Q.2.Which countries have the most Invoices?
Ans.
select count(billing_country) as totalcount,billing_country
from invoice
group by billing_country
order by totalcount DESC
limit 3;

Q.3.What are top 3 values of total invoice?
Ans.
select DISTINCT total from invoice
order by total DESC
limit 3;

Q.4.Which city has the best customers? We would like to throw a promotional Music
Festival in the city we made the most money. Write a query that returns one city that
has the highest sum of invoice totals. Return both the city name & sum of all invoice
totals
Ans.

select sum(total) as total_money,billing_city
from invoice
group by billing_city
order by total_money DESC;

Q.5.Who is the best customer? The customer who has spent the most money will be
declared the best customer. Write a query that returns the person who has spent the
most money
Ans.

select sum(total) as totalmoneyspent,invoice.customer_id,customer.first_name,customer.last_name
from invoice
INNER JOIN customer
on invoice.customer_id=customer.customer_id
group by invoice.customer_id,customer.first_name,customer.last_name
order by totalmoneyspent DESC
limit 1;

----------------------------------------------------------------------------------------
Q.6. Write query to return the email, first name, last name, & Genre of all Rock Music
listeners. Return your list ordered alphabetically by email starting with A

Ans.
select DISTINCT customer.customer_id,first_name,last_name,email
from customer
INNER JOIN invoice
on customer.customer_id=invoice.customer_id
INNER JOIN invoice_line
on invoice.invoice_id=invoice_line.invoice_id
INNER JOIN track
on invoice_line.track_id=track.track_id
INNER JOIN genre
on track.genre_id=genre.genre_id
where genre.genre_id='1'
order by email ASC;

Q.7. Lets invite the artists who have written the most rock music in our dataset. Write a
query that returns the Artist name and total track count of the top 10 rock bands
Ans.


select DISTINCT artist.artist_id,artist.name,count(artist.artist_id)
from artist
inner join album
on artist.artist_id=album.artist_id
inner join track
on album.album_id=track.album_id
where track.genre_id='1'
group by artist.artist_id,artist.name
order by count DESC
limit 10;

Q.8. Return all the track names that have a song length longer than the average song length.
Return the Name and Milliseconds for each track. Order by the song length with the
longest songs listed first
Ans.

select * from track;
select avg(milliseconds) from track;

select track_id,name,milliseconds
from track
where milliseconds>(select avg(milliseconds) from track)
order by milliseconds DESC; 

-------------------------------------------------------------------------
Q.9.. Find how much amount spent by each customer on artists? Write a query to return
customer name, artist name and total spent
Ans.



with BEST_SELLING_ARTIST as(
select artist.artist_id as ArtistID,artist.name as ArtistName,sum(invoice_line.unit_price * invoice_line.quantity) as TotalSales
from artist
INNER JOIN album
on artist.artist_id=album.artist_id
INNER JOIN track
	on album.album_id=track.album_id
INNER JOIN invoice_line
	on track.track_id=invoice_line.track_id
GROUP BY ArtistID
ORDER BY totalsales DESC
LIMIT 1)



select customer.customer_id,customer.first_name as FirstName,customer.last_name as LastName,sum(invoice_line.unit_price * invoice_line.quantity) as TotalSales,ArtistID,ArtistName
from customer
INNER JOIN invoice
on customer.customer_id=invoice.customer_id
INNER JOIN invoice_line
on invoice.invoice_id=invoice_line.invoice_id
INNER JOIN track
on invoice_line.track_id=track.track_id
INNER JOIN album
on track.album_id=album.album_id
INNER JOIN BEST_SELLING_ARTIST
on album.artist_id=best_selling_artist.ArtistID
group by FirstName,LastName,ArtistID,ArtistName,customer.customer_id
order by TotalSales DESC
Limit 1;



Q.10. We want to find out the most popular music Genre for each country. We determine the
most popular genre as the genre with the highest amount of purchases. Write a query
that returns each country along with the top Genre. For countries where the maximum
number of purchases is shared return all Genres
Ans.

with POPULAR_GENRE as (
select DISTINCT country,count(Quantity) as TotalPurchases,track.genre_id,
ROW_NUMBER() over (partition by country order by genre_id) as RowNumber
from customer
inner join invoice
on customer.customer_id=invoice.customer_id
inner join invoice_line
on invoice.invoice_id=invoice_line.invoice_id
INNER JOIN track
on invoice_line.track_id=track.track_id
group by customer.country,track.genre_id
order by TotalPurchases DESC)

select * from POPULAR_GENRE where rownumber<=1;





Q.11.Write a query that determines the customer that has spent the most on music for each
country. Write a query that returns the country along with the top customer and how
much they spent. For countries where the top amount spent is shared, provide all
customers who spent this amount
Ans.


WITH BestCustAccCountry as(
SELECT 
    customer.customer_id,
	customer.first_name,
	customer.last_name,
    invoice.billing_country,
    SUM(invoice.total) AS TotalSpent,
	ROW_NUMBER() over (partition by invoice.billing_country order by SUM(invoice.total) DESC ) as RowNumber
FROM 
    customer
INNER JOIN 
    invoice ON customer.customer_id = invoice.customer_id
GROUP BY 
    customer.customer_id,
	customer.first_name,
	customer.last_name,
    invoice.billing_country
ORDER BY
	invoice.billing_country ASC)

Select * from BestCustAccCountry where rownumber<=1;











