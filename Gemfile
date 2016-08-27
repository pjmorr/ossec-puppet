# encoding: utf-8
# frozen_string_literal: true
source ENV['GEM_SOURCE'] || 'https://rubygems.org'

puppetversion = ENV.key?('PUPPET_VERSION') ? ENV['PUPPET_VERSION'] : ['>= 4.0']

group :test do
  gem 'rake'
  gem 'puppet', puppetversion
  gem 'rspec'
  gem 'rspec-puppet', git: 'https://github.com/rodjek/rspec-puppet.git'
  gem 'rspec-puppet-facts'
  gem 'autorun'
  gem 'rubocop'
  gem 'puppetlabs_spec_helper'
end

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
