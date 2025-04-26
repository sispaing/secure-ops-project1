#!/bin/bash

# Define MySQL credentials
MYSQL_USER="admin"    # Root user or another admin user
MYSQL_PASS="Pazzword123"  # Password for the MySQL user
DB_NAME="projectdb"
VAULT_USER="vault"
VAULT_PASS="vault"
MYSQL_HOST="mysql01.c9megm26srja.ap-southeast-1.rds.amazonaws.com"

# Create the 'vault' user and grant privileges
mysql -h$MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASS -e "
CREATE USER IF NOT EXISTS '$VAULT_USER'@'%' IDENTIFIED BY '$VAULT_PASS';
GRANT CREATE USER ON *.* TO '$VAULT_USER'@'%';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '$VAULT_USER'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
"

# Create the database and table, then insert data
mysql -h$MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASS -e "
USE ${DB_NAME};
CREATE TABLE IF NOT EXISTS CUSTOMERS (
    ID INT AUTO_INCREMENT,
    NAME VARCHAR(20) NOT NULL,
    AGE INT NOT NULL,
    ADDRESS CHAR(25),
    SALARY DECIMAL(18, 2),
    PRIMARY KEY (ID)
);

INSERT INTO CUSTOMERS (ID, NAME, AGE, ADDRESS, SALARY) VALUES
(1, 'Ramesh', 32, 'Ahmedabad', 2000.00),
(2, 'Khilan', 25, 'Delhi', 1500.00),
(3, 'Kaushik', 23, 'Kota', 2000.00),
(4, 'Chaitali', 25, 'Mumbai', 6500.00),
(5, 'Hardik', 27, 'Bhopal', 8500.00),
(6, 'Komal', 22, 'Hyderabad', 4500.00),
(7, 'Muffy', 24, 'Indore', 10000.00);
"

echo "Database setup complete!"