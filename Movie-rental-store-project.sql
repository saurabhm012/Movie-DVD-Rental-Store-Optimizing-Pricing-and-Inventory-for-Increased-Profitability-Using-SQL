# In SQLite

#1.)Foreign Key Constraints in Rental Table Write a query to display the fields that have foreign key constraints related to the "rental" table.

# code:

PRAGMA foreign_key_list(rental);


#2.) Write a query to find the top 5 categories by average film length, and compare their average lengths to the overall average length of films in the database.

#code:

SELECT 
    c.name,
    AVG(f.length) AS avg_length,
    AVG(f.length) - (SELECT AVG(length) FROM film) AS difference
FROM 
    category c
JOIN 
    film_category fc ON c.category_id = fc.category_id
JOIN 
    film f ON fc.film_id = f.film_id
GROUP BY 
    c.name
ORDER BY 
    avg_length DESC
LIMIT 
    5;


#3.) Write a query to find the customers who have rented films from all categories in the database.

#code:

SELECT customer_id
FROM (
    SELECT customer_id, COUNT(DISTINCT category_id) AS rented_categories
    FROM rental
    JOIN inventory ON rental.inventory_id = inventory.inventory_id
    JOIN film_category ON inventory.film_id = film_category.film_id
    GROUP BY customer_id
) AS rented_categories_per_customer
JOIN (
    SELECT COUNT(*) AS total_categories
    FROM category
) AS total_categories_count ON rented_categories_per_customer.rented_categories = total_categories_count.total_categories;


#4.) Write a query to calculate the average rental duration for films that have been rented by more than 5 customers.

#code:

SELECT AVG(rental_duration) AS avg_rental_duration
FROM (
    SELECT film_id, rental_duration
    FROM film
    WHERE film_id IN (
        SELECT inventory.film_id
        FROM rental
        JOIN inventory ON rental.inventory_id = inventory.inventory_id
        GROUP BY inventory.film_id
        HAVING COUNT(DISTINCT rental.customer_id) > 5
    )
) AS films_with_more_than_5_rentals;


#5.) Write a query to determine the top 3 films in terms of the number of rentals in each store.

#code:

SELECT 
    store_id,
    film_id,
    title,
    rental_count
FROM (
    SELECT 
        store_id,
        film_id,
        title,
        rental_count,
        ROW_NUMBER() OVER (PARTITION BY store_id ORDER BY rental_count DESC) AS rank
    FROM (
        SELECT 
            i.store_id,
            i.film_id,
            f.title,
            COUNT(r.rental_id) AS rental_count
        FROM inventory i
        JOIN rental r ON i.inventory_id = r.inventory_id
        JOIN film f ON i.film_id = f.film_id
        GROUP BY i.store_id, i.film_id
    ) AS rental_counts_per_film_per_store
) AS ranked_films
WHERE rank <= 3;


#6.) Write a query to find the actors who have appeared in at least one film from each category.

#code:

SELECT 
    fa.actor_id,
    a.first_name || ' ' || a.last_name AS actor_name
FROM 
    actor a
JOIN 
    film_actor fa ON a.actor_id = fa.actor_id
JOIN 
    film_category fc ON fa.film_id = fc.film_id
GROUP BY 
    fa.actor_id, actor_name
HAVING 
    COUNT(DISTINCT fc.category_id) = (SELECT COUNT(*) FROM category);


#7.) Write a query to find the top 3 countries by the total number of films rented by customers living in those countries.

#code:

SELECT c.Country_id, c.country, COUNT(r.rental_id) AS rental_count
FROM rental r
JOIN customer cu ON r.customer_id = cu.customer_id
JOIN address a ON cu.address_id = a.address_id
JOIN city ct ON a.city_id = ct.city_id
JOIN country c ON ct.country_id = c.country_id
GROUP BY c.country
ORDER BY rental_count DESC
LIMIT 3;


#8.) Write a query to calculate the total revenue generated from rentals by customers living in cities that start with the letter 'S'.

#code:


SELECT 
    SUM(p.amount) AS total_revenue
FROM 
    payment p
JOIN 
    rental r ON p.rental_id = r.rental_id
JOIN 
    customer c ON r.customer_id = c.customer_id
JOIN 
    address a ON c.address_id = a.address_id
JOIN 
    city ci ON a.city_id = ci.city_id
WHERE 
    ci.city LIKE 'S%'


#9.) Write a query to calculate the percentage of customers who have rented the same film more than once.

#code:

WITH RentalCounts AS (
  SELECT
    r.customer_id,
    i.film_id,
    COUNT(r.rental_id) AS rental_count
  FROM rental r
  JOIN inventory i ON r.inventory_id = i.inventory_id
  GROUP BY r.customer_id, i.film_id
  HAVING COUNT(r.rental_id) > 1
),
RepeatCustomers AS (
  SELECT
    COUNT(DISTINCT customer_id) AS repeat_customers
  FROM RentalCounts
),
TotalCustomers AS (
  SELECT
    COUNT(DISTINCT customer_id) AS total_customers
  FROM customer
)
SELECT
  t.total_customers,
  r.repeat_customers,
  (1.0 * r.repeat_customers / t.total_customers) * 100 AS percentage_repeat_customers
FROM TotalCustomers t, RepeatCustomers r;


#10.) Write a query to determine the top 5 categories by total revenue and compare their average revenues to the overall average revenue of films in the database.

#code:

WITH CategoryRevenues AS (
  SELECT
    cat.category_id,
    cat.name,
    SUM(p.amount) AS total_revenue
  FROM payment p
  INNER JOIN rental r ON p.rental_id = r.rental_id
  INNER JOIN inventory i ON r.inventory_id = i.inventory_id
  INNER JOIN film f ON i.film_id = f.film_id
  INNER JOIN film_category fc ON f.film_id = fc.film_id
  INNER JOIN category cat ON fc.category_id = cat.category_id
  GROUP BY cat.category_id, cat.name
), OverallAverageRevenue AS (
  SELECT AVG(total_revenue) AS overall_avg_revenue
  FROM CategoryRevenues
), RankedCategories AS (
  SELECT
    *,
    (total_revenue / (SELECT overall_avg_revenue FROM OverallAverageRevenue) * 100) AS percentage_of_overall_avg_revenue,
    RANK() OVER (ORDER BY total_revenue DESC) AS rank
  FROM CategoryRevenues
)
SELECT
  category_id,
  name,
  total_revenue,
  percentage_of_overall_avg_revenue
FROM RankedCategories
WHERE rank <= 5;


#11.) Write a query to calculate the percentage of revenue generated from films in the top 10% rental rate range.

#code:

WITH Top10Percent AS (
    SELECT rental_rate
    FROM film
    ORDER BY rental_rate DESC
    LIMIT (SELECT COUNT(*) * 0.1 FROM film)
),
Top10PercentRevenue AS (
    SELECT SUM(p.amount) AS revenue
    FROM payment p
    JOIN rental r ON p.rental_id = r.rental_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    WHERE f.rental_rate IN (SELECT rental_rate FROM Top10Percent)
)
SELECT 
    (t10r.revenue / total_revenue * 100) AS top_10_percent_revenue_percentage
FROM 
    Top10PercentRevenue t10r,
    (SELECT SUM(amount) AS total_revenue FROM payment) total


#12.) Write a query to calculate the total revenue generated from rentals of films, broken down by category. The result should include the category name and the total revenue for each category, sorted in descending order of total revenue.

#code:

SELECT 
    c.name AS category,
    SUM(p.amount) AS total_revenue
FROM 
    category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY 
    c.name
ORDER BY 
    category,total_revenue DESC;


#13.) Write a query to calculate the number of distinct customers who have rented films with a rental rate higher than the overall average rental rate in the 'Sci-Fi' category.

#code:

WITH sci_fi_avg_rental_rate AS (
    SELECT 
        AVG(f.rental_rate) AS avg_rental_rate
    FROM 
        film f
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    WHERE 
        c.name = 'Sci-Fi'
),
customers_higher_rental_rate AS (
    SELECT DISTINCT 
        r.customer_id
    FROM 
        rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    WHERE 
        f.film_id IN (SELECT fc.film_id FROM film_category fc JOIN category c ON fc.category_id = c.category_id WHERE c.name = 'Sci-Fi')
        AND f.rental_rate > (SELECT avg_rental_rate FROM sci_fi_avg_rental_rate)
)
SELECT 
    COUNT(*) AS customer_count
FROM 
    customers_higher_rental_rate;


#14.) Write a query to calculate the average rental rate of the top 3 most popular films in terms of the number of rentals, broken down by category and language.

#code:

WITH TopFilms AS (
    SELECT 
        f.film_id,
        f.title,
        fc.category_id,
        f.language_id,
        COUNT(r.rental_id) AS rental_count,
        ROW_NUMBER() OVER(PARTITION BY fc.category_id, f.language_id ORDER BY COUNT(r.rental_id) DESC) AS rn
    FROM 
        rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    JOIN film_category fc ON f.film_id = fc.film_id
    GROUP BY 
        f.film_id,
        f.title,
        fc.category_id,
        f.language_id
)
SELECT 
    c.name AS category,
    l.name AS language,
    AVG(f.rental_rate) AS avg_rental_rate
FROM 
    TopFilms tf
JOIN category c ON tf.category_id = c.category_id
JOIN language l ON tf.language_id = l.language_id
JOIN film f ON tf.film_id = f.film_id
WHERE 
    tf.rn <= 3
GROUP BY 
    c.name,
    l.name
order by avg_rental_rate desc
limit 3;


#15.) Write a query to find the category that has the highest average rental rate for films with a duration longer than the overall average duration of films in that category.

#code:

SELECT c.name AS name,
       AVG(f.rental_rate) AS avg_rental_rate
FROM film_category fc
JOIN category c ON fc.category_id = c.category_id
JOIN film f ON fc.film_id = f.film_id
JOIN (
    SELECT fc.category_id, AVG(f.length) AS avg_duration
    FROM film_category fc
    JOIN film f ON fc.film_id = f.film_id
    GROUP BY fc.category_id
) AS avg_dur_per_category ON fc.category_id = avg_dur_per_category.category_id
WHERE f.length > avg_dur_per_category.avg_duration
GROUP BY c.name
ORDER BY avg_rental_rate DESC
LIMIT 1;


# 16.) Write a query to calculate the total amount of late fees paid by customers who have rented more than 10 films.

#code

SELECT SUM(p.amount) AS total_late_fees
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN customer c ON p.customer_id = c.customer_id
WHERE r.return_date > DATE_ADD(r.rental_date, INTERVAL r.rental_duration DAY)  -- Compare return date with expected return date
AND c.customer_id IN (
    SELECT customer_id
    FROM rental
    GROUP BY customer_id
    HAVING COUNT(rental_id) > 10
);

#Conclusion:
#In conclusion, this project successfully utilized SQL queries to gain valuable insights into the film rental business. By analyzing data related to film categories, customer rentals, revenue generation, and other metrics, we were able to provide actionable recommendations to the store owner. These recommendations include strategies for improving film selection, targeting specific customer segments, optimizing pricing, and managing late fees. Overall, this project demonstrates the power of data analysis in informing business decisions and driving success in the film rental industry.