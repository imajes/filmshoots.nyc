source 'https://rubygems.org'

ruby '2.2.2'

# CORE DEPS
gem 'rails', '~> 4.2.0'
gem 'spring'
gem 'puma'

# EARLY TO APPLY TO OTHER GEMS
gem 'dotenv-rails'

# DB/MODEL
gem 'pg'
gem 'awesome_nested_set'
gem 'active_model_serializers'
gem 'stream_sampler'
gem 'counter_culture'

# SEARCH
gem 'searchkick'

# PARSING
gem 'parslet'
gem 'rltk'
gem 'chronic'
gem 'geocoder'

# GEO
gem 'rgeo'
gem 'activerecord-postgis-adapter', '~> 3.0.0.beta2'

# QUEUE/CACHE
gem 'sidekiq'
gem 'redis-rails'
gem 'sinatra', '>= 1.3.0', require: nil

# JS/APP/UI
gem 'responders'
gem 'oj'
gem 'oj_mimic_json'

# UI HELPERS
gem 'sass-rails'
gem 'less-rails'
gem 'coffee-rails'
gem 'haml-rails'
gem 'jquery-rails'

# UI INTEGRATIONS
gem 'autoprefixer-rails'
gem 'bootstrap-material-design'
gem 'bootstrap-sass', '~> 3.2.0'
gem 'font-awesome-rails'

# ASSET/UI
gem 'therubyracer', require: false
gem 'uglifier',     require: false
gem 'kaminari'

# MIDDLEWARE
gem 'rack-cache', require: 'rack/cache'
gem 'rack-cors',  require: 'rack/cors'

# DEPLOYMENT
gem 'fog', require: 'fog/aws/storage'
gem 'asset_sync'
gem 'rack-heartbeat'

# LAST ON LIST TO ENABLE INSTRUMENTATION 
# OF ALL GEMS.
group :production, :staging do
  gem 'rails_12factor'
  gem 'newrelic_rpm'
  gem 'raygun4ruby'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller', platforms: [:mri_21]
  gem 'foreman'
  gem 'letter_opener'
end

gem 'awesome_print'
group :test, :development do
  gem 'rubocop'
  gem 'simplecov', require: false
  gem 'quiet_assets'
  gem 'terminal-table'
  gem 'pry'
  gem 'pry-rails'
  gem 'pry-remote'
  gem 'pry-stack_explorer'
  gem 'pry-coolline'
  gem 'pry-rescue'
  #gem 'awesome_print'
  gem 'rspec-rails'
  gem 'fuubar'
  gem 'ruby-progressbar', '1.7.1'
  gem 'timecop'
  gem 'factory_girl'
  gem 'factory_girl_rails'
  gem 'forgery'
  gem 'database_cleaner'
  gem 'byebug'
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-bundler'
  # test runs for james; this triggers
  # a blink1(m) device to show red/green
  gem 'guard-shell'
  gem 'guard-blink1'
  gem 'terminal-notifier-guard'
end

group :test do
  gem 'vcr'
  gem 'webmock'
end
