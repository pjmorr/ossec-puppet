# encoding: utf-8
# frozen_string_literal: true
source ENV['GEM_SOURCE'] || 'https://rubygems.org'

puppetversion = ENV.key?('PUPPET_VERSION') ? ENV['PUPPET_VERSION'] : ['>= 4.0']
gem 'metadata-json-lint'
gem 'puppet', puppetversion
gem 'puppetlabs_spec_helper', '>= 1.0.0'
gem 'puppet-lint', '>= 1.0.0'
gem 'facter'
gem 'rspec-puppet', git: 'https://github.com/rodjek/rspec-puppet.git'
gem 'rake'
gem 'rspec'
gem 'rspec-puppet-facts'
gem 'autorun'
gem 'rubocop'
gem 'coveralls',                      require: false
gem 'codeclimate-test-reporter',      require: false
gem 'simplecov',                      require: false
gem 'bundler-audit',                  require: false

group :development do
  gem 'puppet-blacksmith'
  gem 'guard-rake'
  gem 'yard'
end

group :system_tests do
  gem 'beaker'
  gem 'beaker-rspec'
  gem 'beaker-puppet_install_helper'
end
