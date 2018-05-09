# Setup MakerNet in production with Docker

This README tries to describe all the steps to put a MakerNet instance into production on a server,
based on a solution using Docker and docker-compose.

**Note**: _If you require to deploy a new instance based on an existent base image from MakerNet_
_over AWS, follow the [AWS EC2 Image Launch procedure][aws-ec2-launch] guide._

These steps will work on any Docker-compatible cloud provider or local server with a supported
operating system (Ubuntu 16.04/Debian 8).

In order to make it work, please use the same directories structure as described in this guide in
your MakerNet instance folder. You will need to be root through the rest of the setup.

- [Setup the server](#setup-the-server)
  - [Install Docker](#install-docker)
  - [Set the Time Zone](#set-the-time-zone)

## Setup the server

### Basic Configuration

You will need at least 2GB of addressable memory (RAM + swap) to install and use MakerNet. 4 GB RAM are recommended for larger communities.

#### Install Docker

Login into the system as administrator with SSH (`ssh root@server-ip`) and install setup Docker on
it with the following script:

```bash
\curl -sSL https://gist.githubusercontent.com/MakerNetwork/bf04812f4df19f192d6d6d429561fd57/raw/e43c18b619caf628acd00db784ad6b10e8b3ef43/docker_setup.sh | sudo bash
```

It will

* Tune-up the system for production.
* Install Docker and an up-to-date version of docker-compose.
* Retrieve and set the basic configuration scripts.

Once this process has finished, reboot the system:

`sudo reboot`

#### Set the Time Zone

Once the system has rebooted and you can login again, check the time zone where the facilities of
the fablab are located and run:

`sudo dpkg-reconfigure tzdata`

#### Pull the application images

Navigate to the application directory and pull the images with:

  ```bash
  cd makernet
  docker-compose pull
  ```

#### Set the env variables

The following step requires to set the configuration values of the application in the `env` file.

At the veary least, if it is and instance for demo purposes, the values for `SECRET_KEY_BASE` and
`DEVISE_SECRET_KEY` must be set.

Check the [environment configuration values document](env_configuration.md) for a description of the
values that can be set in the `env` file and how them affect the behaviour of the application.

##### Generate and set secrets

Run the following command TWICE from the application directory to obtain randomly generated strings
that can be used as secrets for the application:

`docker-compose run --rm makernet bundle exec rake secret`

Then, open the `env` file and place one string as value for `SECRET_KEY_BASE` and the other as value
for `DEVISE_SECRET_KEY`. (Don't forget to remove the leading `#` character to uncomment the line).

You can open the file for edition with:

`sudo nano .env`

#### Prepare the database

Run the following commands from the application directory to create and prepare the database:

```bash
# create the database
docker-compose run --rm makernet bundle exec rake db:create

# run all the migrations
docker-compose run --rm makernet bundle exec rake db:migrate

# seed the database: replace xxx with your default admin email/password
docker-compose run --rm -e ADMIN_EMAIL=xxx -e ADMIN_PASSWORD=xxx makernet bundle exec rake db:seed
```

#### Build the assets

`docker-compose run --rm makernet bundle exec rake assets:precompile`

#### Prepare ElasticSearch stats

`docker-compose run --rm makernet bundle exec rake fablab:es_build_stats`

#### Run the application with the Dockcer daemon

`docker-compose up -d`

### Advancec configuration with SSL
