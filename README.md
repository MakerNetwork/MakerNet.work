# MakerNet

MakerNet is a management solution for maker spaces, fab-labs and any kind of
community driven innovation space.

- [MakerNet](#makernet)
  - [Summary]
  - [Software stack](#software-stack)
    - [Requirements](#requirements)
  - [Setup a production environment](#setup-a-production-environment)
  - [Setup a development environment](#setup-a-development-environment)
  - [Additional Information](#additional-information)


## Summary

Makernet is a software for administration and control of makerspaces with intuitive interface and easy workflow. The basic functionalities include management of 
Members of makerspaces
Spaces - Rentals
Machines
Trainings and classes
Projects
Plans and subscriptions

With makernet  you can manage the members through to different groups such as students, community members or anything that you need.
The spaces are a physical place that you can use for general purposes such events like workshops, activities, etc. with Makernet you can easily create a page with description, picture and characteristics of your space, then the members of your makerspace can book machines, workshops or events.

The rentals are a physical space that is isolated from the makerspace and you can rent for your project or activity for a longer period of time (usually a month).

Training and classes can easily be defined and put in a page for the user and then they can subscribe and book.
You can create a project to show your work and share with the people subscribed to your space.
Makernet gives you the possibility of creating plans and subscriptions that fit the needs of your groups and also define duration, cost, etc.

### Basic modules:
We can separate the modules into two groups, the user modules and the admin modules, the admin modules include all the user modules/

### User menu
 - Home page: the face of your organization, with a welcome-information message, the latest projects, the last registered members and the upcoming events.
Book machines: an attractive first look of all the machines available in your organization, you can see the detailed page by clicking over images, in detailed page you can include a image , short description of the machine, technical specifications , files to download  such as  user manual , tutorials etc,  also include a list of projects that used this machine and a  link to book it
 - Training and classes : obviously you need to get basic capacitation  , for safety reasons and to perform your abilities. In this page you can find all available training and classes, in detailed view you can find more specific information and tips to prepare for the course.
 - Book spaces: a complete list of spaces , with detailed view
 - Book events: a list of events , you can filter by type like tours, faire, meetup etc
 - Calendar: a  calendar that provides the dates and time for events. Training , classes, the machine booked or free, the calendar of spaces  etc
 - Project gallery: a gallery with projects made in the your organization, include information about material machines etc
 - Atlas of innovation, the space doesn't have a  specific machine or does not fit with your project? Don't worry just look in the atlas map and find the nearest spaces that you could use for your project
subscriptions(this is optional, depending if you give a payment from your users or not makernet fits the needs of non commercial organizations like schools)


### Admin menu
 - You can export and download your data as csv .
 - Manage Calendar: You can add a slot for machines, spaces or workshops, also can export the data as csv
 - Manage machines: add, remove or edit a machine, change the image , technical specification upload files add projects 
 - Manage workshops: add edit or remove the trainings and classes
 - Manage events:add events, categories, themes age ranges  and prices
 - Manage projects elements : add or delete the materials that can be processed in your makerspace, add a theme and licenses
 - Manage user: create , edit or pause members, admins groups, tags and authentication types(local or auth 2)
 - Manage invoices: change the information that will be added to invoices, list and filter for invoices
 - Manage spaces: create edit or delete a space:add a characteristics add files or change space to rental
 - Manage rentals: similar to spaces, change rental to space
 - Manage subscriptions and prices: create a subscriptions plans for trainings machine hours spaces rentals credits and coupons
 - Statistic: analyze your data, check for total members, subscriptions , machine hours , events ,  projects, spaces, export data, see as graphics etc.
 - Customization: take the control of your appearance, change colors, name facility type messages warnings add legal documents add logo , terms of service, background image, change about  page, reservations set time for booking  change cancel reservation rules , etc
 - openAPI Clients : you can provide a token for external connections to your makerspace trough API,  can get machines index, invoices , bookable machines, reservations, training and users.






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
