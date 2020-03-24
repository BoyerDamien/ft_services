CREATE DATABASE wordpress;
CREATE USER "wordpress-admin"@"%" IDENTIFIED BY "password";
GRANT ALL PRIVILEGES ON wordpress.* TO "wordpress-admin"@"%";
FLUSH PRIVILEGES;