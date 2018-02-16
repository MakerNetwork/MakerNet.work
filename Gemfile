source 'https://rubygems.org'

gem 'rails', '4.2.10'

gem 'sass-rails', '5.0.1' # Use SCSS for stylesheets
gem 'compass-rails', '2.0.4' # CSS Authoring Framework
gem 'uglifier', '~> 4.0.1' # Compressor for JavaScript assets
gem 'coffee-rails', '~> 4.1.0' # For .js.coffee assets and views
gem 'therubyracer', '= 0.12.3', platforms: :ruby # Embed the V8 JavaScript interpreter
gem 'jquery-rails' # Main JavaScript library
gem 'jbuilder', '~> 2.5' # Build JSON APIs with ease
gem 'jbuilder_cache_multi' # Retrieve fragments for a collection of objects from the cache
gem 'responders', '~> 2.0' # Rails flash responders to dry up your application
gem 'bootstrap-sass' # Sass-powered version of Bootstrap 3
gem 'font-awesome-rails' #  Font-Awesome web fonts and stylesheets as a Rails engine
gem 'chroma' # Color manipulation and palette generation
#gem 'angularjs-rails' #using bower instead

gem 'puma' # Web server built for concurrency
gem 'foreman' # Manage Procfile-based applications
gem 'kaminari' # Customizable and sophisticated paginator for Ruby webapps
gem 'figaro' # Simple Rails app configuration using ENV and a single YAML file
gem 'mini_magick' # Image processing ruby wrapper for ImageMagick
gem 'carrierwave' # File uploads for Ruby web frameworks
gem 'fog-aws' # Support for AWS file storage
gem 'notify_with' # Very simple notification system
gem 'rails-observers' # Respond to life cycle callbacks to implement trigger-like behavior
gem 'actionpack-page_caching' # action output is stored as a HTML file
gem 'protected_attributes' # Protect attributes from mass-assignment
gem 'message_format' # Parse and format i18n messages using ICU MessageFormat patterns

gem 'sidekiq' # Background job processing
gem 'sidekiq-cron' # Recurring jobs for Sidekiq
gem 'sinatra', require: false # DSL for quickly creating web applications
gem 'recurrence' # A simple library that handles recurring events

gem 'devise' # Flexible authentication solution
gem 'devise-async' # Send Devise's emails in background
gem 'omniauth' # Standardized Multi-Provider Authentication
gem 'omniauth-oauth2' # Generic OAuth2 strategy for OmniAuth
gem 'rolify' # Role management with resource scoping
gem 'pundit' # Minimal authorization through OO design
gem 'has_secure_token' # Generate uniques random tokens for any model

gem 'pg' # Interface to the PostgreSQL RDBMS
gem 'seed_dump' # Task to dump your data to db/seeds.rb
gem 'friendly_id', '~> 5.1.0' # create pretty URL’s and human-friendly strings
gem 'elasticsearch-rails'
gem 'elasticsearch-model'
gem 'elasticsearch-persistence'
gem 'aasm' # State machines for Ruby classes

gem 'prawn' # Fast, Nimble PDF Writer
gem 'prawn-table' # Provides support for tables in Prawn
# XLS files generation
gem 'axlsx', git: 'https://github.com/randym/axlsx', branch: 'release-3.0.0'
gem 'axlsx_rails'


gem 'oj', '~> 3.3.9' # Optimized JSON
gem 'api-pagination' # Link header pagination for Rails and Grape APIs
gem 'apipie-rails' # API documentation tool
gem 'twitter' # Interface to the Twitter API
gem 'twitter-text' # Standardize parsing of Tweet text
gem 'stripe' # Library for the Stripe API
gem 'openlab_ruby' # Consume json API of Openlab-Projects

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  # comment over to use visual debugger (eg. RubyMine), uncomment to use manual debugging
  gem 'byebug'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  # Spring speeds up development by keeping your application running in the background
  gem 'spring'
  gem 'forgery' # Easy and customizable generation of forged data
end

group :development do
  # Preview mail in the browser
  gem 'mailcatcher'
  gem 'awesome_print'
  gem 'capistrano'
  gem 'rvm-capistrano', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'capistrano-maintenance', '0.0.5', require: false
  gem 'active_record_query_trace'
  gem 'coveralls', require: false
  gem 'railroady' # Model and controller UML class diagram generator
end

group :test do
  gem 'database_cleaner'
  gem 'faker'
  gem 'test_after_commit'
  gem 'minitest-reporters'
  gem 'webmock'
  gem 'vcr'
  gem 'pdf-reader'
end

group :production do
  gem 'rails_12factor'
end

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
