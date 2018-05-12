# Setup MakerNet in production with Docker

This README tries to describe all the steps to put a MakerNet instance into production on a server,
based on a solution using Docker and docker-compose.

**Note**: _If you require to deploy a new instance based on an existent base image from MakerNet_
_over AWS, follow the [AWS EC2 Image Launch procedure][aws-ec2-launch] guide._

These steps will work on any Docker-compatible cloud provider or local server with a supported
operating system (Ubuntu 16.04/Debian 8).

In order to make it work, please use the same directories structure as described in this guide in
your MakerNet instance folder. You will need to be root through the rest of the setup.

- [Setup MakerNet in production with Docker](#setup-makernet-in-production-with-docker)
  - [Setup the server](#setup-the-server)
    - [Basic Configuration](#basic-configuration)
      - [Install Docker](#install-docker)
      - [Set the Time Zone](#set-the-time-zone)
      - [Pull the application images](#pull-the-application-images)
      - [Set the env variables](#set-the-env-variables)
        - [Generate and set secrets](#generate-and-set-secrets)
      - [Prepare the database](#prepare-the-database)
      - [Build the assets](#build-the-assets)
      - [Prepare ElasticSearch stats](#prepare-elasticsearch-stats)
      - [Run the application with the Dockcer daemon](#run-the-application-with-the-dockcer-daemon)
    - [Advancec configuration with SSL](#advancec-configuration-with-ssl)
      - [Setup the domain name](#setup-the-domain-name)
      - [Connect through SSH](#connect-through-ssh)
      - [Set up configuration files](#set-up-configuration-files)
        - [Environment](#environment)
        - [NginX](#nginx)
      - [Set up certificates](#set-up-certificates)
      - [SSL certificate with LetsEncrypt](#ssl-certificate-with-letsencrypt)
  - [Docker Utilities](#docker-utilities)


## Setup the server

### Basic Configuration

You will need at least 2GB of addressable memory (RAM + swap) to install and use MakerNet. 4 GB RAM are recommended for larger communities.

#### Install Docker

Login into the system as administrator with SSH (`ssh root@server-ip`) and install setup Docker on
it with the following script:

```bash
\curl -sSL https://gist.githubusercontent.com/MakerNetwork/1393013db25bfe9bf1ccf3dfab49cead/raw/e89c11dca63905541f25c7edbec51cbaaef3ec05/docker_setup.sh | sudo bash
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

#### Setup the domain name

This assumes that you have adquired a domain name and have access to the configuration for it.

1. Replace the IP address of the domain with the IP address of your VPS (This is
   a DNS record type A)
2. **Do not** try to access your domain name right away, DNS are not aware of
   the change yet so **WAIT** and be patient.

#### Connect through SSH

Check that you can connect to the server with this command: `ssh root@your-domain-name`.

Then, you can proceed with the following configuration steps.

#### Set up configuration files

##### Environment

Open the `env` (`sudo nano .env`), set the domain name in the `DEFAULT_HOST` variable and setvthe
`DEFAULT_PROTOCOL` to `https`.

##### NginX

* Remove the `makernet.conf` file from the NginX configuration:

  `sudo rm config/nginx/makernet.conf`

* Copy the example NgniX with SSL configuration file:

  `sudo cp example/nginx_with_ssl.conf.example config/nginx/makernet.conf`

* Open the configuration file (`sudo nano config/nginx/makernet.conf`) an edit the following values:

  - Replace all the ocurrendes of **MAIN_DOMAIN** (example: my-domain.com).
  - Replace **URL_WITH_PROTOCOL_HTTPS** (example: https://www.my-domain.com).
  - If you have extra domains thas point to your server, you can add them by replacing the values in
    **ANOTHER_URL_1**, **ANOTHER_URL_2** (example: .my-domain.us)

#### Set up certificates

**Note**: The application MUST be running with the basic configuration (without SSL) before running
the LetsEncrypt software.

#### SSL certificate with LetsEncrypt

Let's Encrypt is a new Certificate Authority that is free, automated, and open. Let’s Encrypt
certificates expire after 90 days, so automation of renewing your certificates is important. Here is
the setup for a systemd timer and service to renew the certificates and reboot the app Docker
container:

* Generate the `dhparam.pem` file. (This may take some hours):

```bash
sudo mkdir -p /apps/makernet/config/nginx/ssl
cd /apps/makernet/config/nginx/ssl
sudo openssl dhparam -out dhparam.pem 4096
```

* Copy the initial configuration file:

```bash
sudo mkdir -p /apps/makernet/letsencrypt/config/
sudo mkdir -p /apps/makernet/letsencrypt/etc/webrootauth

sudo cp example/webroot.ini.example /apps/makernet/letsencrypt/config/webroot.ini
```

* Edit the `webroot.ini` file:

```bash
# Replace `email` with the admin contact email
# Replace `domains` with the main domain and any other additional domains

sudo nano letsencrypt/config/webroot.ini
```

* Run `docker pull quay.io/letsencrypt/letsencrypt:latest`

* Create file (with sudo) /etc/systemd/system/letsencrypt.service and paste the following
  configuration into it:

```systemd
[Unit]
Description=letsencrypt cert update oneshot
Requires=docker.service

[Service]
Type=oneshot
ExecStart=/usr/bin/docker run --rm --name letsencrypt -v "/apps/makernet/log:/var/log/letsencrypt" -v "/apps/makernet/letsencrypt/etc:/etc/letsencrypt" -v "/apps/makernet/letsencrypt/config:/letsencrypt-config" quay.io/letsencrypt/letsencrypt:latest -c "/letsencrypt-config/webroot.ini" certonly
ExecStartPost=-/usr/bin/docker restart makernet_nginx_1
```

* Create file (with sudo) /etc/systemd/system/letsencrypt.timer and paste the following
  configuration into it:

```systemd
[Unit]
Description=letsencrypt oneshot timer
Requires=docker.service

[Timer]
OnCalendar=*-*-1 06:00:00
Persistent=true
Unit=letsencrypt.service

[Install]
WantedBy=timers.target
```

* Start letsencrypt service:

```bash
sudo systemctl start letsencrypt.service
```

* If there were no errors, remove your app container and run your app to apply the changes running
  the following commands:

```bash
docker-compose down
docker-compose up -d
```

* Visit the domain with using the HTTPS in your browser to check that the site works fine and that
  the encryption is enabled. (A `verified` icon should appear beside the browser address bar).

* Finally, if everything is ok, start letsencrypt timer to update the certificate every 1st of the
  month :

```bash
sudo systemctl enable letsencrypt.timer
sudo systemctl start letsencrypt.timer
# check status with
sudo systemctl list-timers
```

## Docker Utilities

Check the [list of commands](docker_utils.md) that will help you manage the application containers.
