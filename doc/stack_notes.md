# MakerNet Software Stack Notes

- [MakerNet Software Stack Notes](#makernet-software-stack-notes)
  - [Update MakerNet (Production)](#update-makernet-production)
    - [Steps](#steps)
    - [Good to know](#good-to-know)
      - [Is it possible to update several versions at the same time ?](#is-it-possible-to-update-several-versions-at-the-same-time)
  - [PostgreSQL Limitations](#postgresql-limitations)
  - [ElasticSearch](#elasticsearch)
    - [Setup ElasticSearch](#setup-elasticsearch)
    - [Backup and Restore](#backup-and-restore)
  - [Known issues](#known-issues)


## Update MakerNet (Production)

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
   Those commands are always specified in the [CHANGELOG][changelog]
   and prefixed by **[TODO DEPLOY]**.

   They are also present in the [releases page][releases].

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

Be sure to run all the specific commands listed in the [CHANGELOG][changelog]
between your actual and the new version in sequential order. (Example: to update
from 2.4.0 to 2.4.3, you will run the specific commands for the 2.4.1, then for
the 2.4.2 and then for the 2.4.3).

## PostgreSQL Limitations

- While setting up the database, we'll need to activate two PostgreSQL extensions: [unaccent](https://www.postgresql.org/docs/current/static/unaccent.html) and [trigram](https://www.postgresql.org/docs/current/static/pgtrgm.html).
  This can only be achieved if the user, configured in `config/database.yml`, was granted the _SUPERUSER_ role **OR** if these extensions were white-listed.
  So here's your choices, mainly depending on your security requirements:
  - Use the default PostgreSQL super-user (postgres) as the database user of MakerNet.
  - Set your user as _SUPERUSER_; run the following command in `psql`:

    ```sql
    ALTER USER your_desired_user_name WITH SUPERUSER;
    ```

  - Install and configure the PostgreSQL extension [pgextwlist](https://github.com/dimitri/pgextwlist).
    Please follow the instructions detailed on the extension website to whitelist `unaccent` and `trigram` for the user configured in `config/database.yml`.
- Some users may want to use another DBMS than PostgreSQL.
  This is currently not supported, because of some PostgreSQL specific instructions that cannot be efficiently handled with the ActiveRecord ORM:
  - `app/controllers/api/members_controllers.rb@list` is using `ILIKE`
  - `app/controllers/api/invoices_controllers.rb@list` is using `ILIKE` and `date_trunc()`
  - `db/migrate/20160613093842_create_unaccent_function.rb` is using [unaccent](https://www.postgresql.org/docs/current/static/unaccent.html) and [trigram](https://www.postgresql.org/docs/current/static/pgtrgm.html) modules and defines a PL/pgSQL function (`f_unaccent()`)
  - `app/controllers/api/members_controllers.rb@search` is using `f_unaccent()` (see above) and `regexp_replace()`
  - `db/migrate/20150604131525_add_meta_data_to_notifications.rb` is using [jsonb](https://www.postgresql.org/docs/9.4/static/datatype-json.html), a PostgreSQL 9.4+ datatype.
  - `db/migrate/20160915105234_add_transformation_to_o_auth2_mapping.rb` is using [jsonb](https://www.postgresql.org/docs/9.4/static/datatype-json.html), a PostgreSQL 9.4+ datatype.
- If you intend to contribute to the project code, you will need to run the test suite with `rake test`.
  This also requires your user to have the _SUPERUSER_ role.


## ElasticSearch

ElasticSearch is a powerful search engine based on Apache Lucene combined with a NoSQL database used
as a cache to index data and quickly process complex requests on it.

In MakerNet, it is used for the admin's statistics module and to perform searches in projects.

### Setup ElasticSearch

1. Launch the associated rake tasks in the project folder. This will create the fields mappings in
   ElasticSearch DB

   ```bash
   rake fablab:es_build_stats
   ```

2. Every nights, the statistics for the day that just ended are built automatically at 01:00 (AM).
   See [schedule.yml](config/schedule.yml) to modify this behavior.

   If the scheduled task wasn't executed for any reason (eg. you are in a dev environment and your computer was turned off at 1 AM), you can force the statistics data generation in ElasticSearch, running the following command.

   ```bash
   # Here for the 50 last days
   rake fablab:generate_stats[50]
   ```

### Backup and Restore

To backup and restore the ElasticSearch database, use the [elasticsearch-dump](https://github.com/taskrabbit/elasticsearch-dump) tool.

Dump the database with: `elasticdump --input=http://localhost:9200/stats --output=fablab_stats.json`.
Restore it with: `elasticdump --input=fablab_stats.json --output=http://localhost:9200/stats`.

## Known issues

- When browsing a machine page, you may encounter an "InterceptError" in the console and the loading bar will stop loading before reaching its ending.
  This may happen if the machine was created through a seed file without any image.
  To solve this, simply add an image to the machine's profile and refresh the web page.

- When starting the Ruby on Rails server (eg. `foreman s`) you may receive the following error:

        worker.1 | invalid url: redis::6379
        web.1    | Exiting
        worker.1 | ...lib/redis/client.rb...:in `_parse_options'

  This may happen when the `application.yml` file is missing.
  To solve this issue copy `config/application.yml.default` to `config/application.yml`.
  This is required before the first start.

- Due to a stripe limitation, you won't be able to create plans longer than one year.

- When running the tests suite with `rake test`, all tests may fail with errors similar to the following:

        Error:
        ...
        ActiveRecord::InvalidForeignKey: PG::ForeignKeyViolation: ERROR:  insert or update on table "..." violates foreign key constraint "fk_rails_..."
        DETAIL:  Key (group_id)=(1) is not present in table "groups".
        : ...
            test_after_commit (1.0.0) lib/test_after_commit/database_statements.rb:11:in `block in transaction'
            test_after_commit (1.0.0) lib/test_after_commit/database_statements.rb:5:in `transaction'

  This is due to an ActiveRecord behavior witch disable referential integrity in PostgreSQL to load the fixtures.
  PostgreSQL will prevent any users to disable referential integrity on the fly if they doesn't have the `SUPERUSER` role.
  To fix that, logon as the `postgres` user and run the PostgreSQL shell.
  Then, run the following command :

        ALTER ROLE your_database_user WITH SUPERUSER;

  DO NOT do this in a production environment, unless you know what you're doing: this could lead to a serious security issue.

- With Ubuntu 16.04, ElasticSearch may refuse to start even after having configured the service with systemd.
  To solve this issue, you may have to set `START_DAEMON` to `true` in `/etc/default/elasticsearch`.
  Then reload ElasticSearch with:

  ```bash
  sudo systemctl restart elasticsearch.service
  ```
