# require "codeclimate-test-reporter"
# CodeClimate::TestReporter.start

require 'database_cleaner'
require 'byebug'
# require 'vcr'
# require 'timecop'

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start do
    add_filter '/.permits/'
    add_filter '/spec/support/'
    add_filter 'config/initializers/json_formatting.rb'
    add_filter 'config/initializers/console.rb'
  end
end

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
#
# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

# shared contexts and groups to behave like
Dir[Rails.root.join("spec/shared/**/*.rb")].each {|f| require f}
#
# Add additional requires below this line. Rails is not loaded until this point!
#
# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!

  # filter specs
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  config.before(:suite) do
    # prep factory_run tracking
    Permits::FactoryGirl.track_factories
  end

  config.after(:suite) do
    Permits::FactoryGirl.print_statistics
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end

  # database cleaner config
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  # Limits the available syntax to the non-monkey patched syntax that is recommended.
  # For more details, see: http://bit.ly/1B33YNa
  config.disable_monkey_patching!

  # Many RSpec users commonly either run the entire suite or an individual
  # file, and it's useful to allow more verbose output when running an
  # individual spec file.
  config.default_formatter = 'doc' if config.files_to_run.one?

  # Print the 10 slowest examples and example groups at the
  # end of the spec run, to help surface which specs are running
  # particularly slow.
  config.profile_examples = 3

end

