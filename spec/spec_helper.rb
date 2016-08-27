# encoding: utf-8
# frozen_string_literal: true
dir = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift File.join(dir, 'lib')

require 'mocha'
require 'puppet'
require 'rspec'
require 'rspec-puppet-facts'
require 'puppetlabs_spec_helper/module_spec_helper'

include RspecPuppetFacts

# require 'spec/autorun'

# Spec::Runner.configure do |config|
RSpec.configure do |config|
  config.mock_with :mocha
end

# We need this because the RAL uses 'should' as a method.  This
# allows us the same behaviour but with a different method name.
# class Object
#    alias :must :should
# end

unless $executing_puppet
  begin
    gem 'simplecov'
    require 'simplecov'
    formatters = []
    formatters << SimpleCov::Formatter::HTMLFormatter

    begin
      gem 'coveralls'
      require 'coveralls'
      formatters << Coveralls::SimpleCov::Formatter if ENV['TRAVIS']
    rescue Gem::LoadError
      # do nothing
    end

    begin
      gem 'codeclimate-test-reporter'
      require 'codeclimate-test-reporter'
      formatters << CodeClimate::TestReporter::Formatter if ENV['TRAVIS'] && ENV['CODECLIMATE_REPO_TOKEN']
    rescue Gem::LoadError
      # do nothing
    end
    SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[*formatters]
    SimpleCov.start do
      add_filter '/spec/'
      add_filter './vendor/'
      add_filter './.vendor/'
      add_filter '/.vendor/'
      add_filter '/vendor/'
      add_filter '/gems/'
      minimum_coverage 76
      refuse_coverage_drop
    end
  rescue Gem::LoadError
    # do nothing
  end
end

begin
  gem 'pry'
  require 'pry'
rescue Gem::LoadError
  # do nothing
end

module Testing
  module Mock end
end
at_exit { RSpec::Puppet::Coverage.report! }
