#!/bin/bash

until mariadb -h mariadb -u $DB_USER -p"$DB_PASS" -e "SELECT 1"; do
    echo "waiting for database connection..."
    sleep 1
done
echo " database connect..."

if [ ! -f "/wordpress/wp-config.php" ]; then

    cd /wordpress

    echo "Downloading WordPress..."
    wp core download --allow-root
    
    echo "Creating wp-config.php..."
    wp config create \
        --dbname="$DB_NAME" \
        --dbuser="$DB_USER" \
        --dbpass="$DB_PASS" \
        --dbhost="mariadb" \
        --allow-root
    
    echo "Installing WordPress..."
    wp core install \
        --url="$DOMAIN_NAME" \
        --title="$SITE_TITLE" \
        --admin_user="$ADMIN_USER" \
        --admin_password="$ADMIN_PASS" \
        --admin_email="$ADMIN_EMAIL" \
        --skip-email \
        --allow-root

    echo "Creating additional user..."
    wp user create "$WP_USER_NAME" $WP_USER_EMAIL \
                --user_pass=$WP_USER_PASS \
                --allow-root > /dev/null

    echo "WordPress ready!"
fi
echo " run php-fpm..."
exec php-fpm8.2 -F