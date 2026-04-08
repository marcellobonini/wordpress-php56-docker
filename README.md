# WordPress on PHP-5.6 using docker

Running WordPress on PHP-5.6 with MySQL-5.7 on Docker container

## Motivation

- WordPress plugins/themes developers often need to make sure their plugins/themes are also compatible with php5.6
- Official WordPress docker image support start from php7.2

## Coolify

The root `docker-compose.yml` is prepared for Coolify.

It keeps the repo's legacy stack:

- WordPress built from this repo's `Dockerfile` on `php:5.6-apache`
- MySQL `5.7`

Set these environment variables in Coolify:

- `SERVICE_URL_WORDPRESS`
- `SERVICE_USER_WORDPRESS`
- `SERVICE_PASSWORD_WORDPRESS`
- `SERVICE_PASSWORD_ROOT`

WordPress now creates `wp-config.php` on first container start from runtime environment variables, which makes the image easier to deploy in Coolify.

## Local usage

Copy `.env.example` to `.env` if you want to override the defaults.

Build the image:
```sh
docker compose -f docker-compose.yml -f docker-compose.local.yml build
```

Run containers:
```sh
docker compose -f docker-compose.yml -f docker-compose.local.yml up
```

Run containers in the background:
```sh
docker compose -f docker-compose.yml -f docker-compose.local.yml up -d
```

Run with build:
```sh
docker compose -f docker-compose.yml -f docker-compose.local.yml up -d --build
```


## Executing bash of wordpress container
```sh
docker compose -f docker-compose.yml -f docker-compose.local.yml exec wordpress bash
```


## Stop services
`docker compose -f docker-compose.yml -f docker-compose.local.yml stop`
or
`docker compose -f docker-compose.yml -f docker-compose.local.yml down`


## Access the site:

http://localhost:8080/


## Reference

- https://www.sitepoint.com/how-to-manually-build-docker-containers-for-wordpress/
- https://vsupalov.com/docker-arg-env-variable-guide/
