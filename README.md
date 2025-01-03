First you update system: apt-get update
After you should install package: apt-get install sudo -y
Then you install MariaDB and ncat: sudo apt install ncat -ysudo apt install mariadb-server -y

DATABASE PREPARATION
-- Create the schema
CREATE SCHEMA theater_guests;
-- Create the user CREATE USER 'theater_guests'@'localhost' IDENTIFIED BY '1111';
-- Grant all privileges on the schema to the user
GRANT ALL PRIVILEGES ON theater_guests.* TO 'theater_guests'@'localhost';
-- Apply the changes FLUSH PRIVILEGES;

CREATING TABLES:
USE theater_guests;
CREATE TABLE shows (    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,    price INT NOT NULL,
    show_date DATE NOT NULL,    available_seats INT NOT NULL
);
CREATE TABLE tickets (    id INT AUTO_INCREMENT PRIMARY KEY,
    show_id INT NOT NULL,    customer_name VARCHAR(255) NOT NULL,
    number_of_tickets INT NOT NULL,    FOREIGN KEY(show_id) REFERENCES shows(id)
);
To show database:SHOW DATABASES;
USE theater_guests;
SHOW TABLES;
DESCRIBE shows;
SELECT * FROM shows;
For permissions you need to write :
chmod +x server.sh
At the final to run application execute this line:
./server.sh 
