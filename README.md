# Theater Guests Management Application

## Overview

This repository contains a Bash-based application for managing a theater guest system. The application includes the mandatory installation of a web server with a minimal interface running on a Linux operating system. It allows users to save or retrieve data from a MariaDB database and enables communication with other servers or clients using sockets for data transmission or reception.

The project is implemented entirely in Bash and adheres to the following constraints:
- Only Bash scripts are used (no additional programming languages or tools like C, PHP, Python, etc.).
- The focus is on logic, functionality, and implementation, not on graphical aesthetics.

---

## Features

1. **System Preparation**: Automatically sets up the Linux environment.
2. **Database Setup**: Configures a MariaDB database schema and tables for managing shows and tickets.
3. **Socket Communication**: Supports communication between servers/clients using `ncat`.
4. **Bash-Only Implementation**: No dependencies on non-Bash programming languages.

---

## Steps to Install and Run the Application

### 1. Update the System
Update the package lists to ensure the system is up-to-date:
```bash
sudo apt-get update
```
### 2. Install Required Packages
Install the necessary tools and services:
Copy code
```bash
sudo apt-get install sudo -y
sudo apt-get install mariadb-server -y
sudo apt install ncat -y
```
### 3. Database Setup
#### Step 3.1: Create the Schema
Access MariaDB by running:

```bash
Copy code
sudo mysql
```
Then, execute the following SQL command to create the schema:
```
sql
Copy code
CREATE SCHEMA theater_guests;
```
#### Step 3.2: Create a User
Set up a user for database access:
```
sql
Copy code
CREATE USER 'theater_guests'@'localhost' IDENTIFIED BY '1111';
GRANT ALL PRIVILEGES ON theater_guests.* TO 'theater_guests'@'localhost';
FLUSH PRIVILEGES;
```
#### Step 3.3: Create Tables
Switch to the theater_guests database and create the required tables:
```
sql
Copy code
USE theater_guests;

CREATE TABLE shows (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price INT NOT NULL,
    show_date DATE NOT NULL,
    available_seats INT NOT NULL
);

CREATE TABLE tickets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    show_id INT NOT NULL,
    customer_name VARCHAR(255) NOT NULL,
    number_of_tickets INT NOT NULL,
    FOREIGN KEY(show_id) REFERENCES shows(id)
);
```
#### Step 3.4: Verify the Database and Tables
Run the following commands to confirm the database and tables are properly set up:
```
sql
Copy code
SHOW DATABASES;
USE theater_guests;
SHOW TABLES;
DESCRIBE shows;
SELECT * FROM shows;
```
### 4. Grant Permissions to the Bash Script
Make the server script executable:
```
bash
Copy code
chmod +x server.sh
```
### 5. Run the Application
Execute the server script to start the application:
```
bash
Copy code
./server.sh
```
### Project Requirements
1. Web Server: The application includes the setup of a minimal web server.
2. Data Management: User data is read from and stored in a MariaDB database.
3. Socket Communication: The application can transmit and receive data using ncat.

### Notes

1. The project is developed and tested exclusively on Linux using Bash scripting.
2. Graphics, colors, and aesthetics are not evaluated; only logic, functionality, and implementation are considered.
3. A document with all the scripts used in this project is included for reference.
