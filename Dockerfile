FROM ruby:2.4.4-alpine3.7
MAINTAINER info@makernet.work

# Install runtime apk based dependencies.
RUN apk update && apk upgrade
RUN apk add --update curl \
  bash \
  bash-completion \
  nodejs \
  imagemagick \
  supervisor \
  tzdata \
  libc-dev \
  ruby-dev \
  zlib-dev \
  xz-dev \
  postgresql-dev \
  libxml2-dev \
  libxslt-dev \
  libidn-dev

# Install buildtime apk based dependencies.
RUN apk add --update --no-cache --virtual .build-deps alpine-sdk \
  build-base \
  linux-headers \
  git \
  patch

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

# Run Bundle in a cache efficient way
WORKDIR /tmp
COPY Gemfile /tmp/
COPY Gemfile.lock /tmp/
RUN bundle install --binstubs --without development test doc

# Clean up when done.
RUN apk del .build-deps
RUN rm -rf /tmp/* /var/tmp/*

# Web app
RUN mkdir -p /usr/src/app
RUN mkdir -p /usr/src/app/config
RUN mkdir -p /usr/src/app/invoices
RUN mkdir -p /usr/src/app/exports
RUN mkdir -p /usr/src/app/log
RUN mkdir -p /usr/src/app/public/uploads
RUN mkdir -p /usr/src/app/public/assets
RUN mkdir -p /usr/src/app/tmp/sockets
RUN mkdir -p /usr/src/app/tmp/pids

WORKDIR /usr/src/app

COPY docker/database.yml /usr/src/app/config/database.yml

COPY . /usr/src/app

# Volumes
VOLUME /usr/src/app/invoices
VOLUME /usr/src/app/exports
VOLUME /usr/src/app/public
VOLUME /usr/src/app/public/uploads
VOLUME /usr/src/app/public/assets
VOLUME /var/log/supervisor

# Expose port 3000 to the Docker host, so we can access it from the outside.
EXPOSE 3000

# The main command to run when the container starts. Also tell the Rails dev
# server to bind to all interfaces by default.
COPY docker/supervisor.conf /etc/supervisor/conf.d/makernet.conf
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/makernet.conf"]
