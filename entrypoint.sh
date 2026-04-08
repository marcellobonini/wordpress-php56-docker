#!/bin/bash
set -eu

WP_PATH=/var/www/html

# Proper access to the container filesystem.
chown -R www-data:www-data "$WP_PATH"

# In Coolify and other runtime-driven deployments, database credentials are
# injected as environment variables, so create wp-config.php on first start.
if [ ! -f "$WP_PATH/wp-config.php" ]; then
  wp config create \
    --path="$WP_PATH" \
    --dbname="${WORDPRESS_DB_NAME:-wordpress}" \
    --dbuser="${WORDPRESS_DB_USER:-wordpress}" \
    --dbpass="${WORDPRESS_DB_PASSWORD:-wordpress}" \
    --dbhost="${WORDPRESS_DB_HOST:-mysql}" \
    --allow-root \
    --skip-check
fi

exec "$@"
