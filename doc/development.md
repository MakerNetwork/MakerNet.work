# MakerNet Development Environment Instructions

- [MakerNet Development Environment Instructions](#makernet-development-environment-instructions)
    - [Development Virtual Machine](#development-virtual-machine)
        - [Instructions](#instructions)
    - [Development Workflow](#development-workflow)
    - [Emulated Production Environment](#emulated-production-environment)
        - [Instructions](#instructions)
        - [Optional configuration](#optional-configuration)
        - [Docker Utilities](#docker-utilities)


## Development Virtual Machine

Using a virtual machine most of the software dependencies get installed automatically and it avoids
installing a lot of software and services directly on the development machine.

**Note:** The provision scripts configure the sofware dependencies to play nice with each other
while they are inside the same virtual development environment but this means that said
configuration is not optimized for a production environment.

### Instructions

1. Install [Vagrant][0] and [Virtual Box][1] (with the extension package).

2. Retrieve the project from Git

   ```bash
   git clone https://github.com/MakerNetwork/MakerNet.work.git
   ```

3. From the project directory, run:

   ```bash
   vagrant up
   ```

4. Once the virtual machine finished building, reload it and log into it with:

   ```bash
   vagrant reload
   vagrant ssh
   ```

5. While logged in, navigate to the project folder and install the Gemfile dependencies:

   ```bash
   cd /vagrant
   bundle install
   ```

6. Load `.envrc` values as environment variables:

   ```bash
   source ~/.envrc
   ```

   Be sure to check the information about setting up values for the [configuration variables](env_configuration.md).

7. Set a directory for Sidekick pids:

   ```bash
   mkdir -p tmp/pids
   ```

8. Set up the databases. (Note that you should provide the desired admin credentials and that these
   specific set of commands must be used to set up the database as some raw SQL instructions are
   included in the migrations):

   ```bash
   # create database
   bundle exec rake db:create
   # apply migrations
   bundle exec rake db:migrate
   # include seed data
   ADMIN_EMAIL=youradminemail ADMIN_PASSWORD=youradminpassword bundle exec rake db:seed
   # build elasticsearch stats
   bundle exec rake fablab:es_build_stats
   ```

9. Start the application and visit `http://localhost:3000` on your browser to check that it
    works:

   ```bash
   bundle exec foreman s -p 3000
   ```

10. Email notifications will be caught by MailCatcher. To see the emails sent by the platform, open
    your web browser at `http://localhost:1080` to access the MailCatcher interface.

## Development Workflow

These are the recomended set of steps when making changes to the MaketNet codebase. Try to follow
them as much as posible to facilitate the integration of features and fixes into the codebase.

1. Checkout the branch that will be the base for the changes. It is usually the `development` branch,
   but better ask the lead developer.

2. Create a new branch prefixing it with `feature/` for new features or `fix/` to work with bugs.
   Then, checkout your new branch.

3. Start the following processes in different terminals from the `/vagrant` directory of the virtual environment. (Don't forget to run `source ~/.envrc`):
   - `bundle exec mailcatcher --foreground --ip=0.0.0.0`
   - `bundle exec sidekiq -C ./config/sidekiq.yml`
   - `bundle exec rails s -b 0.0.0.0`

4. Star coding! Remember the follwing:
   - Check the application opening a browser at http://localhost:3000 (a private window is
     suggested).
   - Check the emails opening a browser tab at http://localhost:1080
   - You can stop the execution of the application at a certain point using the instruction `byebug`
     inside the application code. Then, a session with the variables and at that point of the
     execution will be avaiable at the Rails terminal. Check the [ByeBug docs][2] to learn more.
   - Use TDD as much as posible.

5. When finished, rebase your branch with the most recent changes in its parent branch, push to
   your branch and issue a pull request to its parent branch.

## Emulated Production Environment

The virtual machine can also emulate the production environment using Docker.

**Note**: Although Docker can be used alone on a developmen system, it is recomended to work with
this virtual machine as the production environment applies optimizations in the host system that may not be suitable for everyday work systems.

### Instructions

1. Install [Vagrant][0] and [Virtual Box][1] (with the extension package).

2. Retrieve the project from Git

   `git clone https://github.com/MakerNetwork/MakerNet.work.git`

3. Open the `Vagrant` file with your editor and change the value to use the Docker provision
   scripts.

   `USE_DOCKER_VERSION = true`

4. From the project directory, run:

   `vagrant up`

5. Once the virtual machine finished building, reload it and log into it with:

   ```bash
   vagrant reload
   vagrant ssh
   ```

6. Login with your Docker credentials. (Note that you must be added as project collaborator over
   Docker Hub beforehand).

   `docker login`

6. Navigate to the project folder and pull the project images. _Note_: By default, the command will
   fetch the most recent build from the maser branch of the project. If using a different build is
   needed, edit the `makernet/docker-compose.yml` file and add the desired tag to the image name.

   ```bash
   cd makernet
   docker-compose pull
   ```

7. It is required to set the Rails and Devise secret in the env file, that can be done by running
   the following commands from the project folder:

   ```bash
   # Generate a new secret string
   docker-compose run --rm makernet bundle exec rake secret
   # Copy the ouput value and place it in the env file
   sudo nano .env
   ```

8. Prepare the database. (Running the migrations manually is required):

   ```bash
   # create the database
   docker-compose run --rm makernet bundle exec rake db:create

   # run all the migrations
   docker-compose run --rm makernet bundle exec rake db:migrate

   # seed the database: replace xxx with your default admin email/password
   docker-compose run --rm -e ADMIN_EMAIL=xxx -e ADMIN_PASSWORD=xxx makernet bundle exec rake db:seed
   ```

9. Build assets

   `docker-compose run --rm makernet bundle exec rake assets:precompile`

10. Prepare ElasticSearch

   `docker-compose run --rm makernet bundle exec rake fablab:es_build_stats`

11. Start the application and visit `http://localhost:3000` on your browser to check that it
    works:

    `docker-compose up -d`

### Optional configuration

12. Set up email provider in the `env` file to receive email notifications:

   ```env
   SMTP_ADDRESS=<your provider server url>
   SMTP_PORT=<usually port 587>
   SMTP_USER_NAME=<service user>
   SMTP_PASSWORD=<service password>
   ```

   Restart the application with `docker-compose restart makernet`

13. Set the desired time zone in the virtual machine:

   `sudo dpkg-reconfigure tzdata`

   Then, edit the `env` file to set the same value in the `TIME_ZONE` variable and restart the
   application with `docker-compose restart makernet`.


### Docker Utilities

Check the [list of commands](docker_utils.md) that will help you manage the application containers.


---
[0]: https://www.vagrantup.com/downloads.html
[1]: https://www.virtualbox.org/wiki/Downloads
[2]: https://github.com/deivid-rodriguez/byebug
