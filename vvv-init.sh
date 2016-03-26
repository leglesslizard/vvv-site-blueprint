# Init script for SITE_NAME

echo "Commencing SITE_NAME"

# Make a database, if we don't already have one
echo "Creating database (if it's not already there)"
mysql -u root --password=root -e "CREATE DATABASE IF NOT EXISTS sitename"
mysql -u root --password=root -e "GRANT ALL PRIVILEGES ON sitename.* TO wp@localhost IDENTIFIED BY 'wp';"

# Download WordPress
if [ ! -d htdocs ]
then
	echo "Installing WordPress using WP CLI"
	mkdir htdocs
	cd htdocs
	wp core download --allow-root
	wp core config --allow-root --dbname="sitename" --dbuser=wp --dbpass=wp --dbhost="localhost" <<PHP
define( 'WP_DEBUG', true );
PHP
	wp core install --allow-root --url=sitename.dev --title="SITE_NAME" --admin_user="admin" --admin_password="password" --admin_email="joey@pie.co.de"

	# Update options
	wp option update --allow-root --quiet blogdescription ''
	wp option update --allow-root --quiet start_of_week 0
	wp option update --allow-root --quiet timezone_string 'Europe/London'
	wp option update --allow-root --quiet permalink_structure '/%postname%/'

	# Delete unneeded default themes and plugins
	wp theme delete --allow-root twentyfourteen
	wp theme delete --allow-root twentyfifteen
	wp plugin delete --allow-root hello
	wp plugin delete --allow-root akismet

	# Get plugins
	wp plugin install --allow-root debug-bar --activate
	wp plugin install --allow-root query-monitor --activate
	wp plugin install --allow-root user-switching pods --activate

fi

# The Vagrant site setup script will restart Nginx for us

echo "SITE_NAME site now installed";
