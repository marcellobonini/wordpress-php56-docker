# Base image
FROM php:5.6-apache

# Install the mysqli extension
RUN docker-php-ext-install mysqli

# Update package sources for the archived Debian Stretch base image and
# install the CLI tools needed during the image build.
RUN set -eux; \
  printf '%s\n' \
    'deb [trusted=yes] http://archive.debian.org/debian stretch main' \
    'deb [trusted=yes] http://archive.debian.org/debian-security stretch/updates main' \
    > /etc/apt/sources.list; \
  printf 'Acquire::Check-Valid-Until "false";\n' > /etc/apt/apt.conf.d/99archive; \
  apt-get update -o Acquire::Check-Valid-Until=false; \
  apt-get install -y --no-install-recommends curl default-mysql-client; \
  rm -rf /var/lib/apt/lists/*

# Install wp-cli as wp
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar  && \
  chmod +x wp-cli.phar && \
  mv wp-cli.phar /usr/local/bin/wp

# Download and extract WordPress files on /var/www/html
RUN wp core download --allow-root

# Get args from docker-composer.yml
ARG WORDPRESS_DB_NAME
ARG WORDPRESS_DB_USER
ARG WORDPRESS_DB_PASSWORD
ARG WORDPRESS_DB_HOST

# Creating wp-config.php file on /var/www/html
RUN wp config create --dbname=${WORDPRESS_DB_NAME} --dbuser=${WORDPRESS_DB_USER} --dbpass=${WORDPRESS_DB_PASSWORD} --dbhost=${WORDPRESS_DB_HOST} --allow-root --skip-check

COPY entrypoint.sh /entrypoint.sh

# makes the script executable
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["apache2-foreground"]
