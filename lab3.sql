-- Lab 3.01

USE sakila;

-- 1)Drop column picture from staff.
ALTER TABLE staff
DROP COLUMN picture;

-- 2)A new person is hired to help Jon. Her name is TAMMY SANDERS, 
-- and she is a customer. Update the database accordingly.

INSERT INTO staff(staff_id,first_name,last_name,address_id,email,store_id,active,username,password,last_update) 
VALUES (3,"TAMMY","SANDERS",79,"tammy.sanders@sakilacustomer.org",2,1,"TAMMY",0,"2006-02-15 04:57:20");

SELECT *
FROM STAFF;

-- 3)Add rental for movie "Academy Dinosaur" by Charlotte Hunter from Mike Hillyer at Store 1. You can use current date for the rental_date column in the rental table. Hint: Check the columns in the table rental and see what information you would need to add there. You can query those pieces of information. For eg., you would notice that you need customer_id information as well. To get that you can use the following query:
-- select customer_id from sakila.customer
-- where first_name = 'CHARLOTTE' and last_name = 'HUNTER';

-- Activity 2



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