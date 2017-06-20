# frozen_string_literal: true
require 'simplecov'
SimpleCov.start

# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require File.expand_path('../../test/dummy/config/environment.rb', __FILE__)
ActiveRecord::Migrator.migrations_paths =
  [File.expand_path('../../test/dummy/db/migrate', __FILE__)]

require 'rails/test_help'
require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/rails'
require 'minitest/rails/capybara'
require 'minitest/reporters'

require 'support/factory_girl'
require 'support/devise'

Minitest::Reporters.use! [
  # Minitest::Reporters::SpecReporter.new,
  Minitest::Reporters::DefaultReporter.new
]

# Filter out Minitest backtrace while allowing backtrace from other libraries
# to be shown.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

Rails::TestUnitReporter.executable = 'bin/test'
Rails.application.load_seed

# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path =
    File.expand_path('../fixtures', __FILE__)
  ActionDispatch::IntegrationTest.fixture_path =
    ActiveSupport::TestCase.fixture_path
  ActiveSupport::TestCase.file_fixture_path =
    ActiveSupport::TestCase.fixture_path + '/files'
  ActiveSupport::TestCase.fixtures :all
end

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL

  # Reset sessions and driver between tests
  # Use super wherever this method is redefined in your individual test classes
  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end

# Allow signing in of test users with devise
ApplicationController.allow_forgery_protection = false

ActionDispatch::IntegrationTest.extend Minitest::Spec::DSL
Minitest::Unit::TestCase.include Capybara::DSL
Minitest::Spec.include Capybara::DSL

# Because it makes sense, and it's what I've always wanted
module Minitest
  class Spec
    class << self
      alias the it
    end
  end
end

class MockDataObject
  def initialize(attrs = {})
    attrs.each do |key, value|
      instance_variable_set(:"@#{key}", value)
      self.class.class_eval do
        attr_reader key
      end
    end
  end

  def self.descends_from_active_record?
    true
  end

  def self.table_name
    name.tableize
  end

  def self.name
    'Mock'
  end

  def self.find(*args)
    raise StandardError,
          "Couldn't find #{name} with id #{args[0].inspect}" unless args[0]
    new id: args[0]
  end

  def self.find_or_initialize_by(args)
    raise StandardError,
          'Syntax error: find_or_`initialize by expects a hash:
          User.find_or_initialize_by(:id => @user.id)' unless args.is_a?(Hash)
    new id: args[:id]
  end
end

class MockUser < MockDataObject
  def initialize(*roles)
    options = roles.last.is_a?(::Hash) ? roles.pop : {}
    super({ role_symbols: roles, login: hash }.merge(options))
  end

  def initialize_copy
    @role_symbols = @role_symbols.clone
  end
end
