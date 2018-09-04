# Docker utils with docker-compose for MakerNet

## Restart app

`docker-compose restart makernet`

## Remove app

`docker-compose down makernet`

## Restart all containers

`docker-compose restart`

## Remove all containers

`docker-compose down`

## Start all containers

`docker-compose up -d`

## Open a bash in the app context

`docker-compose run --rm makernet bash`

## Show services status

`docker-compose ps`

## Restart nginx container

`docker-compose restart nginx`

## Example of command passing env variables

`docker-compose run --rm -e ADMIN_EMAIL=xxx -e ADMIN_PASSWORD=xxx makernet bundle exec rake db:seed`
