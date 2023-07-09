-- Challenge
-- Write SQL queries to perform the following tasks using the Sakila database:

USE sakila;

-- 1. Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
SELECT COUNT(*) AS num_copies FROM inventory
WHERE film_id = (SELECT film_id FROM film
    WHERE title = 'Hunchback Impossible');

-- 2. List all films whose length is longer than the average length of all the films in the Sakila database.
SELECT * FROM film
WHERE length > (SELECT AVG(length) FROM film);

-- 3. Use a subquery to display all actors who appear in the film "Alone Trip".
SELECT actor_id, first_name, last_name FROM actor
WHERE actor_id IN (SELECT actor_id FROM film_actor
    WHERE film_id = (SELECT film_id FROM film
        WHERE title = 'Alone Trip'));

-- 4. Sales have been lagging among young families, and you want to target family movies for a promotion. 
-- Identify all movies categorized as family films.
SELECT * FROM film
WHERE film_id IN (SELECT film_id FROM film_category
    WHERE category_id = (SELECT category_id FROM category
        WHERE name = 'Family'));

-- 5. Retrieve the name and email of customers from Canada using both subqueries and joins. 
-- To use joins, you will need to identify the relevant tables and their primary and foreign keys.
SELECT first_name, last_name, email FROM customer
WHERE address_id IN (SELECT address_id FROM address
    WHERE city_id IN (SELECT city_id FROM city
        WHERE country_id = (SELECT country_id FROM country
            WHERE country = 'Canada')));

-- OR USING JOINS  

SELECT customer.first_name, customer.last_name, customer.email FROM customer
JOIN address ON customer.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
JOIN country ON city.country_id = country.country_id
WHERE country.country = 'Canada';

-- 6. Determine which films were starred by the most prolific actor in the Sakila database. 
-- A prolific actor is defined as the actor who has acted in the most number of films. 
-- First, you will need to find the most prolific actor and then use that actor_id to find the different films that 
-- he or she starred in.
SELECT film.title FROM film
JOIN film_actor ON film.film_id = film_actor.film_id
WHERE film_actor.actor_id = (SELECT actor_id FROM actor
    WHERE actor_id = (SELECT actor_id FROM film_actor
        GROUP BY actor_id
        ORDER BY COUNT(*) DESC LIMIT 1));


-- 7. Find the films rented by the most profitable customer in the Sakila database. You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.
SELECT film.title FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
JOIN payment ON rental.rental_id = payment.rental_id
WHERE payment.customer_id = (SELECT customer_id FROM payment
    GROUP BY customer_id
    ORDER BY SUM(amount) DESC LIMIT 1);


-- 8. Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the 
-- total_amount spent by each client. You can use subqueries to accomplish this.
SELECT customer_id, total_amount_spent
FROM (SELECT customer_id, SUM(amount) AS total_amount_spent FROM payment
    GROUP BY customer_id) AS payment_summary
WHERE total_amount_spent > (
    SELECT AVG(total_amount_spent)
    FROM (
        SELECT SUM(amount) AS total_amount_spent FROM payment
        GROUP BY customer_id) AS avg_payment_summary);

