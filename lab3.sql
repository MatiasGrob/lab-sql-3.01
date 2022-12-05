-- Lab 3.01

USE sakila;





-- Lab 3.03

-- 1How many copies of the film Hunchback Impossible exist in the inventory system?
select title as film_name, count(inventory_id) as file_copies
from inventory
join film
using (film_id)
where title = "Hunchback Impossible"
group by title;

-- 2List all films whose length is longer than the average of all the films.
select *
from film
where length > (select avg(length)from film);

-- 3Use subqueries to display all actors who appear in the film Alone Trip.
select first_name, last_name, title as film_name
from actor
join film_actor
using(actor_id)
join film
using (film_id)
where film_id = (select film_id from film where title = "Alone trip");

-- 4Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.
select name as category, title
from film
join film_category
using(film_id)
join category
using (category_id)
where category_id = (select category_id from category where name = "family");


-- 5Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
select first_name, last_name, Email
from customer c
join address a
using(address_id)
where city_id IN 
(
select city_id from city
where country_id = (select country_id from country where country = "Canada"));

-- 6Which are films starred by the most prolific actor? Most prolific actor is defined as the actor 
-- that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.+

select actor_id, title as film_name
from film
join film_actor
using (film_id)
where actor_id = 
(select actor_id
from film_actor
group by actor_id
order by count(film_id) desc
limit 1);

-- 7Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
select distinct title as film_name
from film
join inventory
using (film_id)
join rental
using (inventory_id)
where customer_id = 
(select customer_id
from payment
group by customer_id
order by sum(amount) desc
limit 1);

-- 8Customers who spent more than the average payments. (average oyments per customers, and then the customers than > x.

select first_name, last_name, email
from customer
where customer_id IN 
( select customer_id
from payment
group by customer_id
having sum(amount) >
(select avg(amount) as avg_pay
from payment) ) ;