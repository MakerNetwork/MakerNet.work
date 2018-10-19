# MakerNet

MakerNet is a management solution for maker spaces, fab-labs and any kind of
community driven innovation space.

- [MakerNet](#makernet)
  - [Software stack](#software-stack)
    - [Requirements](#requirements)
  - [Setup a production environment](#setup-a-production-environment)
  - [Setup a development environment](#setup-a-development-environment)
  - [Additional Information](#additional-information)

## Software stack

This is a Ruby on Rails / AngularJS web application that runs on the following software:

- Ubuntu LTS 18.04 / Debian 8
- Ruby 2.4.x & Rails 4.2.x
- Git
- Redis
- Sidekiq
- Elasticsearch
- PostgreSQL

### Requirements

**Minimum** (ex: up to 200 users)
- 1 core procesor
- 2GB RAM
- 30GB Hard Drive

**Recommended** (ex: up to 1000 users)
- 2 core procesor
- 4GB RAM
- 60GB Hard Drive

## Setup a production environment

To run MakerNet as a production application, conteinarization with Docker is used. Refer to the
Docker [production install instructions](doc/production.md).

## Setup a development environment

In you intend to run MakerNet on your local machine to contribute to the project development, you
can set it up with the virtual environment
[instructions](doc/development.md).

## Additional Information

Review the following links to learn more about the workings of MakerNet.

* [Environment Configuration](env_configuration.md)
* [Localization (Language and Time Settings)](localization.md)
* [Notes on the Software Stack](stack_notes.md)
* [Additional Capabilities](additional_capabilities.md)
