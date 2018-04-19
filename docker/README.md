# Install Fabmanager app in production with Docker

This README tries to describe all the steps to put a MakerNet instance into
production on a server, based on a solution using Docker and Docker-compose.

These steps will work on any Docker-compatible cloud provider or local server.

In order to make it work, please use the same directories structure as described
in this guide in your MakerNet instance folder. You will need to be root through
the rest of the setup.

##### Table of contents

1. [Preliminary steps](#preliminary-steps)<br/>
1.1. Setup the server<br/>
1.2. Setup the domain name<br/>
1.3. Connect through SSH<br/>
1.4. Prepare the server<br/>
1.5. Retrieve the initial configuration files<br/>
1.6. Setup folders and env file<br/>
1.7. Setup nginx configuration<br/>
1.8. SSL certificate with LetsEncrypt<br/>
1.9. Requirements
2. [Install MakerNet](#install-makernet)<br/>
2.1. Add docker-compose.yml file<br/>
2.2. Pull images<br/>
2.3. Setup database<br/>
2.4. Build assets<br/>
2.5. Prepare Elasticsearch (search engine)<br/>
2.6. Start all services<br/>
2.7. Generate SSL certificate by Let's encrypt
4. [Docker utils](#docker-utils)
5. [Update MakerNet](#update-makernet)<br/>
5.1. Steps<br/>
5.2. Good to know

<a name="preliminary-steps"></a>
## Preliminary steps

<a name="setup-the-server"></a>
### Setup the server

There are many hosting providers on the internet, providing affordable virtual
private servers (VPS). Here's a non exhaustive list:
- [DigitalOcean](https://www.digitalocean.com/pricing/#droplet)
- [OVH](https://www.ovh.com/vps/)
- [Amazon](https://aws.amazon.com/ec2/)
- [Gandi](https://v4.gandi.net/hebergement/serveur/prix)
- [Ikoula](https://express.ikoula.com/fr/serveur-virtuel)
- [1&1](https://www.1and1.fr/serveurs-virtuels)
- [GoDaddy](https://fr.godaddy.com/hosting/vps-hosting)
- [and many others...](https://www.google.com/search?q=vps+hosting)

Choose one, depending on your budget, on the server's location, on the uptime
guarantee, etc.

You will need at least 2GB of addressable memory (RAM + swap) to install and use
MakerNet. We recommend 4 GB RAM for larger communities.

On DigitalOcean, create a Droplet with One-click apps **"Docker on Ubuntu 16.04 LTS"**.
This way, Docker and Docker-compose are preinstalled. Choose a datacenter and
set the hostname as your domain name.

With other providers, choose a [supported operating system](https://github.com/LaCasemate/fab-manager/blob/master/README.md#software-stack) and install docker on it:
- [Debian](https://docs.docker.com/engine/installation/linux/docker-ce/debian/)
- [Ubuntu](https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/)

Then install [Docker Compose](https://docs.docker.com/compose/install/)

### Setup the domain name

There are many domain name registrars on the internet, you may choose one that
fit your needs. You can find an exhaustive list [on the ICANN website](https://www.icann.org/registrar-reports/accredited-list.html)

1. Once done, buy a domain name on it
2. Replace the IP address of the domain with the IP address of your VPS (This is
   a DNS record type A)
3. **Do not** try to access your domain name right away, DNS are not aware of
   the change yet so **WAIT** and be patient.

### Connect through SSH

You can already connect to the server with this command: `ssh root@server-ip`.
When DNS propagation will be done, you will be able to connect to the server
with `ssh root@your-domain-name`.

### Prepare the server

Before installing MakerNet, we recommend you to:
- Upgrade your system
- Setup the server timezone
- Add at least 2GB of swap memory
- Protect your SSH connection by forcing it through a RSA key

You can run the following script as root to easily perform all these operations:

```bash
\curl -sSL https://gist.githubusercontent.com/MakerNetwork/1393013db25bfe9bf1ccf3dfab49cead/raw/633276a9d8868b61f8649353951d620bb144f792/prepare-vps.sh | bash
```

<a name="retrieve-config-files"></a>
### Retrieve the initial configuration files

```bash
\curl -sSL https://gist.githubusercontent.com/MakerNetwork/1393013db25bfe9bf1ccf3dfab49cead/raw/ee7dd56ce8d797f1e8e83ac8038195031bce1efc/setup.sh | bash
```

### Setup folders and env file

Create the config folder, copy the environnement variables configuration file
and edit it:

```bash
mkdir -p /apps/makernet/config
cd /apps/makernet
cp example/env.example config/env
ln -s config/env .env
vi config/env
# or use your favorite text editor instead of vi (nano, ne...)
```

You need to carefully configure each variable before starting fab-manager.
Please refer to the [MakerNet README](https://github.com/MakerNetwork/MakerNet.work#environment-configuration)
for explanations about those variables.

### Setup nginx configuration

Create the nginx folder, copy the example configuration file and edit it:

```bash
mkdir -p /apps/makernet/config/nginx
# whether you want you fab-manager to use SSL encryption or not, you should copy one of the following file
### with SSL ###
cp example/nginx_with_ssl.conf.example config/nginx/makernet.conf
### OR without SSL ###
cp example/nginx.conf.example config/nginx/makernet.conf

vi config/nginx/makernet.conf
# or use your favorite text editor instead of vi (nano, ne...)
```

Customize the following values:
* Replace **MAIN_DOMAIN** (example: mymakerspace.com).
* Replace **URL_WITH_PROTOCOL_HTTPS** (example: https://www.mymakerspace.com).
* Replace **ANOTHER_URL_1**, **ANOTHER_URL_2** (example: .mymakerspace.us)

### SSL certificate with LetsEncrypt

**FOLLOW THOSE INSTRUCTIONS ONLY IF YOU WANT TO USE SSL**.

If you have chosen the SSL configuration at the previous point, you must follow
these instructions to make it work.

Let's Encrypt is a new Certificate Authority that is free, automated, and open.
Let’s Encrypt certificates expire after 90 days, so automation of renewing your
certificates is important. Here is the setup for a systemd timer and service to
renew the certificates and reboot the app Docker container:

Generate the dhparam.pem file

```bash
mkdir -p /apps/makernet/config/nginx/ssl
cd /apps/makernet/config/nginx/ssl
openssl dhparam -out dhparam.pem 4096
```

Copy the initial configuration file and customize it

```bash
cd /apps/makernet/
mkdir -p letsencrypt/config/
mkdir -p letsencrypt/etc/webrootauth

cp example/webroot.ini.example /apps/makernet/letsencrypt/config/webroot.ini
vi letsencrypt/config/webroot.ini
# or use your favorite text editor instead of vi (nano, ne...)
```

Run `docker pull quay.io/letsencrypt/letsencrypt:latest`

Create file (with sudo) /etc/systemd/system/letsencrypt.service and paste the
following configuration into it:

```systemd
[Unit]
Description=letsencrypt cert update oneshot
Requires=docker.service

[Service]
Type=oneshot
ExecStart=/usr/bin/docker run --rm --name letsencrypt -v "/apps/makernet/log:/var/log/letsencrypt" -v "/apps/makernet/letsencrypt/etc:/etc/letsencrypt" -v "/apps/makernet/letsencrypt/config:/letsencrypt-config" quay.io/letsencrypt/letsencrypt:latest -c "/letsencrypt-config/webroot.ini" certonly
ExecStartPost=-/usr/bin/docker restart makernet_nginx_1
```

Create file (with sudo) /etc/systemd/system/letsencrypt.timer and paste the
following configuration into it:

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

That's all for the moment. Keep on with the installation, we'll complete that
part after deployment in the [Generate SSL certificate by Let's encrypt](#generate-ssl-cert-letsencrypt).

### Requirements

Verify that Docker and Docker-composer are installed: (This is normally the case
if you used a pre-configured image.)

```bash
docker info
docker-compose -v
```

Otherwise, follow the instructions provided in the section [Setup the server](#setup-the-server) to install.

<a name="install-makernet"></a>
## Install MakerNet

### Add docker-compose.yml file

You should already have a `docker-compose.yml` file in your app folder `/apps/makernet`.
Otherwise, see the section [Retrieve the initial configuration files](#retrieve-config-files) to get it.

The docker-compose commands must be launched from the folder `/apps/makernet`.

### pull images

```bash
docker-compose pull
```

### setup database

```bash
docker-compose run --rm makernet bundle exec rake db:create # create the database
docker-compose run --rm makernet bundle exec rake db:migrate # run all the migrations
# replace xxx with your default admin email/password
docker-compose run --rm -e ADMIN_EMAIL=xxx -e ADMIN_PASSWORD=xxx makernet bundle exec rake db:seed # seed the database
```

### build assets

`docker-compose run --rm makernet bundle exec rake assets:precompile`

### prepare Elasticsearch (search engine)

`docker-compose run --rm makernet bundle exec rake fablab:es_build_stats`

### start all services

`docker-compose up -d`

<a name="generate-ssl-cert-letsencrypt"></a>
### Generate SSL certificate by Let's encrypt

**Important: app must be run on http before starting letsencrypt**

Start letsencrypt service :
```bash
sudo systemctl start letsencrypt.service
```

If the certificate was successfully generated then update the nginx
configuration file and activate the ssl port and certificate editing the file
`/apps/makernet/config/nginx/makernet.conf`.

Remove your app container and run your app to apply the changes running the
following commands:

```bash
docker-compose down
docker-compose up -d
```

Finally, if everything is ok, start letsencrypt timer to update the certificate
every 1st of the month :

```bash
sudo systemctl enable letsencrypt.timer
sudo systemctl start letsencrypt.timer
# check status with
sudo systemctl list-timers
```

<a name="docker-utils"></a>
## Docker utils with docker-compose

### Restart app

`docker-compose restart makernet`

### Remove app

`docker-compose down makernet`

### Restart all containers

`docker-compose restart`

### Remove all containers

`docker-compose down`

### Start all containers

`docker-compose up -d`

### Open a bash in the app context

`docker-compose run --rm makernet bash`

### Show services status

`docker-compose ps`

### Restart nginx container

`docker-compose restart nginx`

### Example of command passing env variables

`docker-compose run --rm -e ADMIN_EMAIL=xxx -e ADMIN_PASSWORD=xxx makernet bundle exec rake db:seed`

<a name="update-makernet"></a>
## Update MakerNet

*This procedure updates MakerNet to the most recent version by default.*

### Steps

When a new version is available, this is how to update makernet app in a
production environment, using docker-compose :

1. go to your app folder

   `cd /apps/makernet`

2. pull last docker images

   `docker-compose pull`

3. stop the app

   `docker-compose stop makernet`

4. remove old assets

   `rm -Rf public/assets/`

5. compile new assets

   `docker-compose run --rm makernet bundle exec rake assets:precompile`

6. run specific commands

   **Do not forget** to check if there are commands to run for your upgrade.
   Those commands are always specified in the [CHANGELOG](https://github.com/LaCasemate/fab-manager/blob/master/CHANGELOG.md)
   and prefixed by **[TODO DEPLOY]**.

   They are also present in the [releases page](https://github.com/LaCasemate/fab-manager/releases).

   Those commands execute specific tasks and have to be run by hand.

7. restart all containers

   ```bash
     docker-compose down
     docker-compose up -d
   ```

You can check that all containers are running with `docker ps`.

### Good to know

#### Is it possible to update several versions at the same time ?

Yes, indeed. It's the default behaviour as `docker-compose pull` command will
fetch the latest versions of the docker images.

Be sure to run all the specific commands listed in the [CHANGELOG](https://github.com/LaCasemate/fab-manager/blob/master/CHANGELOG.md)
between your actual and the new version in sequential order. (Example: to update
from 2.4.0 to 2.4.3, you will run the specific commands for the 2.4.1, then for
the 2.4.2 and then for the 2.4.3).
