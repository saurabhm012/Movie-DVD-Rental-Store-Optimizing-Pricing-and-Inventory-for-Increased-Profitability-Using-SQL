CREATE DATABASE Movie_DVD_Store;

use Movie_DVD_Store;


-- Create the country table
CREATE TABLE country (
country_id SMALLINT AUTO_INCREMENT PRIMARY KEY,
country VARCHAR(50) NOT NULL,
last_update TIMESTAMP
);
-- Create the city table
CREATE TABLE city (
city_id SMALLINT AUTO_INCREMENT PRIMARY KEY,
city VARCHAR(50) NOT NULL,
country_id SMALLINT,
last_update TIMESTAMP,
FOREIGN KEY (country_id) REFERENCES country(country_id)
);
-- Create the address table
CREATE TABLE address (
address_id SMALLINT AUTO_INCREMENT PRIMARY KEY,
address VARCHAR(50),
address2 VARCHAR(50),
district VARCHAR(20),
city_id SMALLINT,
postal_code VARCHAR(10),
phone VARCHAR(20),
location GEOMETRY,
last_update TIMESTAMP,
FOREIGN KEY (city_id) REFERENCES city(city_id)
);
-- Create the store table
CREATE TABLE store (
store_id TINYINT AUTO_INCREMENT PRIMARY KEY,
manager_staff_id TINYINT,
address_id SMALLINT,
last_update TIMESTAMP,
FOREIGN KEY (address_id) REFERENCES address(address_id)
);
-- Create the customer table
CREATE TABLE customer (
customer_id SMALLINT AUTO_INCREMENT PRIMARY KEY,
store_id TINYINT,
first_name VARCHAR(50),
last_name VARCHAR(50),
email VARCHAR(50),
address_id SMALLINT,
active TINYINT,
create_date DATETIME,
last_update TIMESTAMP,
FOREIGN KEY (store_id) REFERENCES store(store_id),
FOREIGN KEY (address_id) REFERENCES address(address_id)
);
-- Create the staff table
CREATE TABLE staff (
staff_id TINYINT AUTO_INCREMENT PRIMARY KEY,
first_name VARCHAR(45),
last_name VARCHAR(45),
address_id SMALLINT,
email VARCHAR(50),
store_id TINYINT,
active TINYINT,
username VARCHAR(16),
password VARCHAR(40),
last_update TIMESTAMP,
FOREIGN KEY (address_id) REFERENCES address(address_id),
FOREIGN KEY (store_id) REFERENCES store(store_id)
);
-- Create the film table
CREATE TABLE film (
film_id SMALLINT AUTO_INCREMENT PRIMARY KEY,
title VARCHAR(128),
description TEXT,
release_year YEAR,
language_id TINYINT,
original_language_id TINYINT,
rental_duration TINYINT,
rental_rate DECIMAL(4,2),
length SMALLINT,
replacement_cost DECIMAL(5,2),
rating ENUM('G', 'PG', 'PG-13', 'R', 'NC-17'),
special_features SET('Trailers', 'Commentaries', 'Deleted Scenes', 'Behind the Scenes'),
last_update TIMESTAMP,
FOREIGN KEY (language_id) REFERENCES language(language_id)
);
-- Create the category table
CREATE TABLE category (
category_id TINYINT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(25),
last_update TIMESTAMP
);
-- Create the film_category table
CREATE TABLE film_category (
film_id SMALLINT,
category_id TINYINT,
last_update TIMESTAMP,
PRIMARY KEY (film_id, category_id),
FOREIGN KEY (film_id) REFERENCES film(film_id),
FOREIGN KEY (category_id) REFERENCES category(category_id)
);
-- Create the language table
CREATE TABLE language (
language_id TINYINT AUTO_INCREMENT PRIMARY KEY,
name CHAR(20),
last_update TIMESTAMP
);
-- Create the actor table
CREATE TABLE actor (
actor_id SMALLINT AUTO_INCREMENT PRIMARY KEY,
first_name VARCHAR(45),
last_name VARCHAR(45),
last_update TIMESTAMP
);
-- Create the film_actor table
CREATE TABLE film_actor (
actor_id SMALLINT,
film_id SMALLINT,
last_update TIMESTAMP,
PRIMARY KEY (actor_id, film_id),
FOREIGN KEY (actor_id) REFERENCES actor(actor_id),
FOREIGN KEY (film_id) REFERENCES film(film_id)
);
-- Create the inventory table
CREATE TABLE inventory (
inventory_id MEDIUMINT AUTO_INCREMENT PRIMARY KEY,
film_id SMALLINT,
store_id TINYINT,
last_update TIMESTAMP,
FOREIGN KEY (film_id) REFERENCES film(film_id),
FOREIGN KEY (store_id) REFERENCES store(store_id)
);
-- Create the rental table
CREATE TABLE rental (
rental_id INT AUTO_INCREMENT PRIMARY KEY,
rental_date DATETIME,
inventory_id MEDIUMINT,
customer_id SMALLINT,
return_date DATETIME,
staff_id TINYINT,
last_update TIMESTAMP,
FOREIGN KEY (inventory_id) REFERENCES inventory(inventory_id),
FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);
-- Create the payment table
CREATE TABLE payment (
payment_id SMALLINT AUTO_INCREMENT PRIMARY KEY,
customer_id SMALLINT,
staff_id TINYINT,
rental_id INT,
amount DECIMAL(5,2),
payment_date DATETIME,
last_update TIMESTAMP,
FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
FOREIGN KEY (staff_id) REFERENCES staff(staff_id),
FOREIGN KEY (rental_id) REFERENCES rental(rental_id)
);


# Inserting records

-- Insert records into country table
INSERT INTO country (country, last_update) VALUES
('United States', NOW()),
('Canada', NOW()),
('Mexico', NOW()),
('Brazil', NOW()),
('Argentina', NOW()),
('Germany', NOW()),
('France', NOW()),
('United Kingdom', NOW()),
('Italy', NOW()),
('Spain', NOW()),
('Japan', NOW()),
('China', NOW()),
('India', NOW()),
('Australia', NOW()),
('New Zealand', NOW()),
('Russia', NOW()),
('South Korea', NOW()),
('South Africa', NOW()),
('Egypt', NOW()),
('Nigeria', NOW());

-- Insert records into city table
INSERT INTO city (city, country_id, last_update) VALUES
('Los Angeles', 1, NOW()),
('New York', 1, NOW()),
('Chicago', 1, NOW()),
('Toronto', 2, NOW()),
('Montreal', 2, NOW()),
('Mexico City', 3, NOW()),
('Sao Paulo', 4, NOW()),
('Buenos Aires', 5, NOW()),
('Berlin', 6, NOW()),
('Paris', 7, NOW()),
('London', 8, NOW()),
('Rome', 9, NOW()),
('Madrid', 10, NOW()),
('Tokyo', 11, NOW()),
('Shanghai', 12, NOW()),
('Mumbai', 13, NOW()),
('Sydney', 14, NOW()),
('Auckland', 15, NOW()),
('Moscow', 16, NOW()),
('Seoul', 17, NOW());

-- Insert records into address table
INSERT INTO address (address, address2, district, city_id, postal_code, phone, location, last_update) VALUES
('123 Main Street', NULL, 'Downtown', 1, '90210', '555-1212', ST_GeomFromText('POINT(-118.2437 34.0522)'), NOW()),
('456 Elm Street', NULL, 'Midtown', 2, '10001', '555-3434', ST_GeomFromText('POINT(-74.0060 40.7128)'), NOW()),
('789 Oak Street', NULL, 'Lincoln Park', 3, '60614', '555-5656', ST_GeomFromText('POINT(-87.6298 41.8781)'), NOW()),
('1011 Maple Street', NULL, 'York', 4, 'M6H 1L6', '416-555-1212', ST_GeomFromText('POINT(-79.3832 43.6532)'), NOW()),
('1213 Birch Street', NULL, 'Downtown', 5, 'H2X 1X2', '514-555-3434', ST_GeomFromText('POINT(-73.5673 45.5017)'), NOW()),
('1415 Pine Street', NULL, 'Cuauhtémoc', 6, '06500', '55-5555-1212', ST_GeomFromText('POINT(-99.1332 19.4326)'), NOW()),
('1617 Cedar Street', NULL, 'Pinheiros', 7, '05422-000', '11-5555-3434', ST_GeomFromText('POINT(-46.6388 -23.5505)'), NOW()),
('1819 Willow Street', NULL, 'Palermo', 8, '1425', '11-5555-5656', ST_GeomFromText('POINT(-58.3816 -34.5833)'), NOW()),
('2021 Oak Street', NULL, 'Mitte', 9, '10117', '30-5555-1212', ST_GeomFromText('POINT(13.4050 52.5200)'), NOW()),
('2223 Maple Street', NULL, '10th arrondissement', 10, '75010', '1-42-55-55-55', ST_GeomFromText('POINT(2.3522 48.8566)'), NOW()),
('2425 Birch Street', NULL, 'City of Westminster', 11, 'SW1A 0AA', '20-7555-1212', ST_GeomFromText('POINT(-0.1278 51.5074)'), NOW()),
('2627 Pine Street', NULL, 'Roma', 12, '00184', '06-5555-3434', ST_GeomFromText('POINT(12.4964 41.8902)'), NOW()),
('2829 Cedar Street', NULL, 'Centro', 13, '28001', '91-5555-5656', ST_GeomFromText('POINT(-3.7038 40.4168)'), NOW()),
('3031 Willow Street', NULL, 'Chiyoda', 14, '100-0004', '3-5555-1212', ST_GeomFromText('POINT(139.6917 35.6895)'), NOW()),
('3233 Oak Street', NULL, 'Huangpu', 15, '200000', '21-5555-3434', ST_GeomFromText('POINT(121.4737 31.2304)'), NOW()),
('3435 Maple Street', NULL, 'Mumbai Suburban', 16, '400001', '22-5555-5656', ST_GeomFromText('POINT(72.8777 19.0760)'), NOW()),
('3637 Birch Street', NULL, 'City of Sydney', 17, '2000', '2-9555-1212', ST_GeomFromText('POINT(151.2070 -33.8688)'), NOW()),
('3839 Pine Street', NULL, 'Auckland Central', 18, '1010', '9-5555-3434', ST_GeomFromText('POINT(174.7683 -36.8505)'), NOW()),
('4041 Cedar Street', NULL, 'Central', 19, '125009', '495-555-1212', ST_GeomFromText('POINT(37.6175 55.7558)'), NOW()),
('4243 Willow Street', NULL, 'Jung-gu', 20, '04521', '2-5555-5656', ST_GeomFromText('POINT(126.9780 37.5665)'), NOW());

-- Insert records into store table
INSERT INTO store (manager_staff_id, address_id, last_update) VALUES
(1, 1, NOW()),
(2, 2, NOW()),
(3, 3, NOW()),
(4, 4, NOW()),
(5, 5, NOW()),
(6, 6, NOW()),
(7, 7, NOW()),
(8, 8, NOW()),
(9, 9, NOW()),
(10, 10, NOW()),
(11, 11, NOW()),
(12, 12, NOW()),
(13, 13, NOW()),
(14, 14, NOW()),
(15, 15, NOW()),
(16, 16, NOW()),
(17, 17, NOW()),
(18, 18, NOW()),
(19, 19, NOW()),
(20, 20, NOW());

-- Insert records into customer table
INSERT INTO customer (store_id, first_name, last_name, email, address_id, active, create_date, last_update) VALUES
(1, 'John', 'Smith', 'john.smith@example.com', 1, 1, '2023-01-01', NOW()),
(2, 'Jane', 'Doe', 'jane.doe@example.com', 2, 1, '2023-02-02', NOW()),
(3, 'David', 'Lee', 'david.lee@example.com', 3, 1, '2023-03-03', NOW()),
(4, 'Sarah', 'Wilson', 'sarah.wilson@example.com', 4, 1, '2023-04-04', NOW()),
(5, 'Michael', 'Brown', 'michael.brown@example.com', 5, 1, '2023-05-05', NOW()),
(1, 'Emily', 'Davis', 'emily.davis@example.com', 1, 1, '2023-06-06', NOW()),
(2, 'James', 'Miller', 'james.miller@example.com', 2, 1, '2023-07-07', NOW()),
(3, 'Olivia', 'Wilson', 'olivia.wilson@example.com', 3, 1, '2023-08-08', NOW()),
(4, 'Noah', 'Moore', 'noah.moore@example.com', 4, 1, '2023-09-09', NOW()),
(5, 'Ava', 'Taylor', 'ava.taylor@example.com', 5, 1, '2023-10-10', NOW()),
(1, 'Ethan', 'Anderson', 'ethan.anderson@example.com', 1, 1, '2023-11-11', NOW()),
(2, 'Sophia', 'Thomas', 'sophia.thomas@example.com', 2, 1, '2023-12-12', NOW()),
(3, 'Liam', 'Jackson', 'liam.jackson@example.com', 3, 1, '2023-01-01', NOW()),
(4, 'Isabella', 'White', 'isabella.white@example.com', 4, 1, '2023-02-02', NOW()),
(5, 'Matthew', 'Martin', 'matthew.martin@example.com', 5, 1, '2023-03-03', NOW()),
(1, 'Mia', 'Thompson', 'mia.thompson@example.com', 1, 1, '2023-04-04', NOW()),
(2, 'William', 'Garcia', 'william.garcia@example.com', 2, 1, '2023-05-05', NOW()),
(3, 'Charlotte', 'Martinez', 'charlotte.martinez@example.com', 3, 1, '2023-06-06', NOW()),
(4, 'Benjamin', 'Robinson', 'benjamin.robinson@example.com', 4, 1, '2023-07-07', NOW()),
(5, 'Abigail', 'Clark', 'abigail.clark@example.com', 5, 1, '2023-08-08', NOW());


-- Insert records into staff table
INSERT INTO staff (first_name, last_name, address_id, email, store_id, active, username, password, last_update) VALUES
('Mike', 'Jones', 1, 'mike.jones@example.com', 1, 1, 'mjones', 'password123', NOW()),
('Amy', 'Smith', 2, 'amy.smith@example.com', 2, 1, 'asmith', 'password456', NOW()),
('Peter', 'Brown', 3, 'peter.brown@example.com', 3, 1, 'pbrown', 'password789', NOW()),
('Lisa', 'Davis', 4, 'lisa.davis@example.com', 4, 1, 'ldavis', 'password000', NOW()),
('Chris', 'Wilson', 5, 'chris.wilson@example.com', 5, 1, 'cwilson', 'password111', NOW()),
('Mary', 'Miller', 6, 'mary.miller@example.com', 1, 1, 'mmiller', 'password222', NOW()),
('John', 'Taylor', 7, 'john.taylor@example.com', 2, 1, 'jtaylor', 'password333', NOW()),
('Susan', 'Anderson', 8, 'susan.anderson@example.com', 3, 1, 'sanderson', 'password444', NOW()),
('David', 'Thomas', 9, 'david.thomas@example.com', 4, 1, 'dthomas', 'password555', NOW()),
('Jennifer', 'Jackson', 10, 'jennifer.jackson@example.com', 5, 1, 'jjackson', 'password666', NOW()),
('Robert', 'White', 11, 'robert.white@example.com', 1, 1, 'rwhite', 'password777', NOW()),
('Barbara', 'Martin', 12, 'barbara.martin@example.com', 2, 1, 'bmartin', 'password888', NOW()),
('Michael', 'Thompson', 13, 'michael.thompson@example.com', 3, 1, 'mthompson', 'password999', NOW()),
('Linda', 'Garcia', 14, 'linda.garcia@example.com', 4, 1, 'lgarcia', 'password001', NOW()),
('William', 'Martinez', 15, 'william.martinez@example.com', 5, 1, 'wmartinez', 'password002', NOW()),
('Elizabeth', 'Robinson', 16, 'elizabeth.robinson@example.com', 1, 1, 'erobinson', 'password003', NOW()),
('James', 'Clark', 17, 'james.clark@example.com', 2, 1, 'jclark', 'password004', NOW()),
('Patricia', 'Lewis', 18, 'patricia.lewis@example.com', 3, 1, 'plewis', 'password005', NOW()),
('Maria', 'Lee', 19, 'maria.lee@example.com', 4, 1, 'mlee', 'password006', NOW()),
('Charles', 'Walker', 20, 'charles.walker@example.com', 5, 1, 'cwalker', 'password007', NOW());


-- Insert records into film table
INSERT INTO film (title, description, release_year, language_id, original_language_id, rental_duration, rental_rate, length, replacement_cost, rating, special_features, last_update) VALUES
('The Shawshank Redemption', 'Two imprisoned men bond over a period of decades, finding solace and eventual redemption through acts of common decency.', 1994, 1, 1, 7, 4.99, 142, 25.99, 'R', 'Trailers, Deleted Scenes', NOW()),
('The Godfather', 'The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant youngest son.', 1972, 1, 1, 7, 3.99, 175, 20.99, 'R', 'Trailers, Commentaries, Deleted Scenes', NOW()),
('The Dark Knight', 'When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.', 2008, 1, 1, 7, 4.99, 152, 29.99, 'PG-13', 'Trailers, Commentaries, Deleted Scenes', NOW()),
('Pulp Fiction', "The lives of two mob hitmen, a boxer, a gangster's wife, and a pair of diner bandits intertwine in four tales of violence and redemption.", 1994, 1, 1, 7, 4.99, 154, 24.99, 'R', 'Trailers, Commentaries, Deleted Scenes, Behind the Scenes', NOW()),
('The Lord of the Rings: The Return of the King', "Gandalf and Aragorn lead the World of Men against Sauron's army to prevent him from conquering Middle-earth.", 2003, 1, 1, 7, 3.99, 201, 20.99, 'PG-13', 'Trailers, Commentaries, Deleted Scenes', NOW()),
('Forrest Gump', 'A man with a low IQ has accomplished great things in his life and has been present at historical events.', 1994, 1, 1, 7, 2.99, 142, 20.99, 'PG-13', 'Trailers, Commentaries, Deleted Scenes', NOW()),
('Fight Club', 'An insomniac office worker looking for a way to change his life crosses paths with a devil-may-care soap maker and they form an underground fight club that evolves into something much, much more.', 1999, 1, 1, 7, 4.99, 139, 24.99, 'R', 'Trailers, Deleted Scenes', NOW()),
('Inception', 'A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea into the mind of a CEO.', 2010, 1, 1, 7, 4.99, 148, 29.99, 'PG-13', 'Trailers, Commentaries, Deleted Scenes', NOW()),
('The Matrix', 'A computer hacker learns from mysterious rebels about the true nature of his reality and his role in the war against its controllers.', 1999, 1, 1, 7, 4.99, 136, 24.99, 'R', 'Trailers, Commentaries, Deleted Scenes, Behind the Scenes', NOW()),
('The Silence of the Lambs', 'A young F.B.I. cadet must receive the help of an incarcerated and manipulative cannibal killer to help catch another serial killer, a madman who skins his victims.', 1991, 1, 1, 7, 4.99, 118, 24.99, 'R', 'Trailers, Deleted Scenes', NOW()),
("Schindler's List'", 'In German-occupied Poland during World War II, Oskar Schindler gradually becomes concerned for his Jewish workforce after witnessing their persecution and sets out to rescue them from the horrors of the Holocaust.', 1993, 1, 1, 7, 3.99, 195, 20.99, 'R', 'Trailers, Commentaries, Deleted Scenes', NOW()),
('Saving Private Ryan', 'Following the Normandy landings, a group of U.S. soldiers goes behind enemy lines to search for a paratrooper whose brothers have been killed in action.', 1998, 1, 1, 7, 4.99, 169, 29.99, 'R', 'Trailers, Commentaries, Deleted Scenes, Behind the Scenes', NOW()),
('The Green Mile', 'A death row prison guard befriends a gentle giant accused of a terrible crime, on death row in a Louisiana prison.', 1999, 1, 1, 7, 3.99, 189, 20.99, 'R', 'Trailers, Commentaries, Deleted Scenes', NOW()),
('The Sixth Sense', 'A child psychologist treats a young boy who communicates with spirits.', 1999, 1, 1, 7, 4.99, 107, 24.99, 'PG-13', 'Trailers, Commentaries, Deleted Scenes', NOW()),
('A Beautiful Mind', 'A brilliant but eccentric mathematician is recruited by the government to work on a code-breaking project during the Cold War. However, his life takes a dark turn when he is diagnosed with paranoid schizophrenia.', 2001, 1, 1, 7, 3.99, 132, 20.99, 'PG-13', 'Trailers, Commentaries, Deleted Scenes', NOW()),
('The Lord of the Rings: The Fellowship of the Ring', 'A young hobbit, Frodo Baggins, must leave his home to take the One Ring, an evil artifact created by the Dark Lord Sauron, to the fires of Mount Doom in the land of Mordor in order to destroy it.', 2001, 1, 1, 7, 3.99, 178, 20.99, 'PG-13', 'Trailers, Commentaries, Deleted Scenes', NOW()),
('The Lord of the Rings: The Two Towers', 'Frodo and Sam continue their journey to Mordor to destroy the One Ring, while Aragorn, Legolas, and Gimli pursue the orcs who have captured Merry and Pippin.', 2002, 1, 1, 7, 3.99, 179, 20.99, 'PG-13', 'Trailers, Commentaries, Deleted Scenes', NOW()),
('The Departed', 'An undercover state trooper and a mole in the Irish mob find themselves on a collision course in this gritty crime drama.', 2006, 1, 1, 7, 4.99, 151, 29.99, 'R', 'Trailers, Commentaries, Deleted Scenes, Behind the Scenes', NOW()),
('The Prestige', 'Two ambitious stage magicians are involved in a rivalry that turns deadly.', 2006, 1, 1, 7, 4.99, 130, 24.99, 'R', 'Trailers, Commentaries, Deleted Scenes', NOW()),
('The Wolf of Wall Street', 'Based on the true story of Jordan Belfort, a Long Island stockbroker who served 22 months in prison for securities fraud and money laundering.', 2013, 1, 1, 7, 4.99, 180, 29.99, 'R', 'Trailers, Commentaries, Deleted Scenes, Behind the Scenes', NOW()),
('Interstellar', 'A team of explorers travel through a wormhole in space in search of a new home for humanity.', 2014, 1, 1, 7, 4.99, 169, 29.99, 'PG-13', 'Trailers, Commentaries, Deleted Scenes, Behind the Scenes', NOW()),
('The Martian', 'An astronaut becomes stranded on Mars after his crewmates assume he is dead and must use his ingenuity to survive and signal for help.', 2015, 1, 1, 7, 4.99, 144, 29.99, 'PG-13', 'Trailers, Commentaries, Deleted Scenes', NOW()),
('Avengers: Endgame', 'The remaining Avengers and their allies must assemble once more to confront Thanos and reverse the devastating events that have unfolded in the wake of his actions.', 2019, 1, 1, 7, 4.99, 181, 29.99, 'PG-13', 'Trailers, Commentaries, Deleted Scenes, Behind the Scenes', NOW());

-- Insert records into category table
INSERT INTO category (name, last_update) VALUES
('Action', NOW()),
('Animation', NOW()),
('Children', NOW()),
('Classics', NOW()),
('Comedy', NOW()),
('Crime', NOW()),
('Documentary', NOW()),
('Drama', NOW()),
('Family', NOW()),
('Fantasy', NOW()),
('Foreign', NOW()),
('Game-Show', NOW()),
('Horror', NOW()),
('Music', NOW()),
('Mystery', NOW()),
('News', NOW()),
('Romance', NOW()),
('Sci-Fi', NOW()),
('Sports', NOW()),
('Thriller', NOW()),
('Travel', NOW()),
('War', NOW()),
('Western', NOW());


-- Insert records into film_category table
INSERT INTO film_category (film_id, category_id, last_update) VALUES
(1, 1, NOW()),
(2, 1, NOW()),
(3, 1, NOW()),
(4, 1, NOW()),
(5, 1, NOW()),
(6, 2, NOW()),
(7, 2, NOW()),
(8, 3, NOW()),
(9, 4, NOW()),
(10, 5, NOW()),
(11, 6, NOW()),
(12, 7, NOW()),
(13, 8, NOW()),
(14, 9, NOW()),
(15, 10, NOW()),
(16, 11, NOW()),
(17, 12, NOW()),
(18, 13, NOW()),
(19, 14, NOW()),
(20, 15, NOW()),
(1, 16, NOW()),
(2, 17, NOW()),
(3, 18, NOW()),
(4, 19, NOW()),
(5, 20, NOW()),
(6, 1, NOW()),
(7, 2, NOW()),
(8, 3, NOW()),
(9, 4, NOW()),
(10, 5, NOW()),
(11, 6, NOW()),
(12, 7, NOW()),
(13, 8, NOW()),
(14, 9, NOW()),
(15, 10, NOW()),
(16, 11, NOW()),
(17, 12, NOW()),
(18, 13, NOW()),
(19, 14, NOW()),
(20, 15, NOW());


-- Insert records into language table
INSERT INTO language (name, last_update) VALUES
('English', NOW()),
('French', NOW()),
('Spanish', NOW()),
('German', NOW()),
('Japanese', NOW()),
('Chinese', NOW()),
('Arabic', NOW()),
('Russian', NOW()),
('Portuguese', NOW()),
('Italian', NOW()),
('Korean', NOW()),
('Hindi', NOW()),
('Bengali', NOW()),
('Turkish', NOW()),
('Thai', NOW()),
('Vietnamese', NOW()),
('Persian', NOW()),
('Indonesian', NOW()),
('Malay', NOW()),
('Urdu');


-- Insert records into actor table
INSERT INTO actor (first_name, last_name, last_update) VALUES
('Tom', 'Hanks', NOW()),
('Leonardo', 'DiCaprio', NOW()),
('Morgan', 'Freeman', NOW()),
('Robert', 'De Niro', NOW()),
('Al', 'Pacino', NOW()),
('Brad', 'Pitt', NOW()),
('George', 'Clooney', NOW()),
('Meryl', 'Streep', NOW()),
('Daniel', 'Day-Lewis', NOW()),
('Denzel', 'Washington', NOW()),
('Scarlett', 'Johansson', NOW()),
('Chris', 'Evans', NOW()),
('Mark', 'Ruffalo', NOW()),
('Robert', 'Downey Jr.', NOW()),
('Chris', 'Pratt', NOW()),
('Emma', 'Watson', NOW()),
('Ryan', 'Reynolds', NOW()),
('Dwayne', 'Johnson', NOW()),
('Tom', 'Cruise', NOW()),
('Jennifer', 'Lawrence');


-- Insert records into film_actor table
INSERT INTO film_actor (actor_id, film_id, last_update) VALUES
(1, 1, NOW()),
(2, 2, NOW()),
(3, 3, NOW()),
(4, 4, NOW()),
(5, 5, NOW()),
(6, 6, NOW()),
(7, 7, NOW()),
(8, 8, NOW()),
(9, 9, NOW()),
(10, 10, NOW()),
(11, 11, NOW()),
(12, 12, NOW()),
(13, 13, NOW()),
(14, 14, NOW()),
(15, 15, NOW()),
(16, 16, NOW()),
(17, 17, NOW()),
(18, 18, NOW()),
(19, 19, NOW()),
(20, 20, NOW()),
(1, 1, NOW()),
(2, 2, NOW()),
(3, 3, NOW()),
(4, 4, NOW()),
(5, 5, NOW()),
(6, 6, NOW()),
(7, 7, NOW()),
(8, 8, NOW()),
(9, 9, NOW()),
(10, 10, NOW()),
(11, 11, NOW()),
(12, 12, NOW()),
(13, 13, NOW()),
(14, 14, NOW()),
(15, 15, NOW()),
(16, 16, NOW()),
(17, 17, NOW()),
(18, 18, NOW()),
(19, 19, NOW()),
(20, 20, NOW());


-- Insert records into inventory table
INSERT INTO inventory (film_id, store_id, last_update) VALUES
(1, 1, NOW()),
(2, 2, NOW()),
(3, 3, NOW()),
(4, 4, NOW()),
(5, 5, NOW()),
(6, 1, NOW()),
(7, 2, NOW()),
(8, 3, NOW()),
(9, 4, NOW()),
(10, 5, NOW()),
(11, 1, NOW()),
(12, 2, NOW()),
(13, 3, NOW()),
(14, 4, NOW()),
(15, 5, NOW()),
(16, 1, NOW()),
(17, 2, NOW()),
(18, 3, NOW()),
(19, 4, NOW()),
(20, 5, NOW()),
(1, 1, NOW()),
(2, 2, NOW()),
(3, 3, NOW()),
(4, 4, NOW()),
(5, 5, NOW()),
(6, 1, NOW()),
(7, 2, NOW()),
(8, 3, NOW()),
(9, 4, NOW()),
(10, 5, NOW());


-- Insert records into rental table
INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id, last_update) VALUES
('2023-01-01', 1, 1, '2023-01-08', 1, NOW()),
('2023-01-02', 2, 2, '2023-01-09', 2, NOW()),
('2023-01-03', 3, 3, '2023-01-10', 3, NOW()),
('2023-01-04', 4, 4, '2023-01-11', 4, NOW()),
('2023-01-05', 5, 5, '2023-01-12', 5, NOW()),
('2023-01-06', 6, 6, '2023-01-13', 6, NOW()),
('2023-01-07', 7, 7, '2023-01-14', 7, NOW()),
('2023-01-08', 8, 8, '2023-01-15', 8, NOW()),
('2023-01-09', 9, 9, '2023-01-16', 9, NOW()),
('2023-01-10', 10, 10, '2023-01-17', 10, NOW()),
('2023-01-11', 11, 11, '2023-01-18', 11, NOW()),
('2023-01-12', 12, 12, '2023-01-19', 12, NOW()),
('2023-01-13', 13, 13, '2023-01-20', 13, NOW()),
('2023-01-14', 14, 14, '2023-01-21', 14, NOW()),
('2023-01-15', 15, 15, '2023-01-22', 15, NOW()),
('2023-01-16', 16, 16, '2023-01-23', 16, NOW()),
('2023-01-17', 17, 17, '2023-01-24', 17, NOW()),
('2023-01-18', 18, 18, '2023-01-25', 18, NOW()),
('2023-01-19', 19, 19, '2023-01-26', 19, NOW()),
('2023-01-20', 20, 20, '2023-01-27', 20, NOW());


-- Insert records into payment table
INSERT INTO payment (customer_id, staff_id, rental_id, amount, payment_date, last_update) VALUES
(1, 1, 1, 4.99, '2023-01-08', NOW()),
(2, 2, 2, 3.99, '2023-01-09', NOW()),
(3, 3, 3, 4.99, '2023-01-10', NOW()),
(4, 4, 4, 2.99, '2023-01-11', NOW()),
(5, 5, 5, 4.99, '2023-01-12', NOW()),
(6, 6, 6, 3.99, '2023-01-13', NOW()),
(7, 7, 7, 4.99, '2023-01-14', NOW()),
(8, 8, 8, 2.99, '2023-01-15', NOW()),
(9, 9, 9, 4.99, '2023-01-16', NOW()),
(10, 10, 10, 3.99, '2023-01-17', NOW()),
(11, 11, 11, 4.99, '2023-01-18', NOW()),
(12, 12, 12, 2.99, '2023-01-19', NOW()),
(13, 13, 13, 4.99, '2023-01-20', NOW()),
(14, 14, 14, 3.99, '2023-01-21', NOW()),
(15, 15, 15, 4.99, '2023-01-22', NOW()),
(16, 16, 16, 2.99, '2023-01-23', NOW()),
(17, 17, 17, 4.99, '2023-01-24', NOW()),
(18, 18, 18, 3.99, '2023-01-25', NOW()),
(19, 19, 19, 4.99, '2023-01-26', NOW()),
(20, 20, 20, 2.99, '2023-01-27', NOW());
