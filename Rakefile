# encoding: utf-8
# frozen_string_literal: true
require 'rubygems'
require 'bundler'
require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'metadata-json-lint/rake_task'
require 'rspec/core'
require 'rspec/core/rake_task'
require 'rdoc/task'
require 'rake'
require 'bundler/audit/task'
require 'rubocop/rake_task'

# These two gems aren't always present, for instance
# on Travis with --without development
begin
  require 'puppet_blacksmith/rake_tasks'
end

begin
  Bundler.setup(:default)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts 'Run `bundle install` to install missing gems'
  exit e.status_code
end

desc 'Code coverage detail'
task :simplecov do
  ENV['COVERAGE'] = 'true'
  Rake::Task['spec'].execute
end

PuppetLint.configuration.send('disable_only_variable_string')
PuppetLint.configuration.send('disable_140chars')
PuppetLint.configuration.send('disable_80chars')
PuppetLint.configuration.ignore_paths = [
  'spec/**/*.pp',
  'pkg/**/*.pp',
  'tests/**/*.pp',
  'vendor/**/*.pp'
]
PuppetLint.configuration.fail_on_warnings = true

desc 'Validate manifests, templates, and ruby files'
task :validate do
  PuppetLint.configuration.ignore_paths = ['dev/**/*.pp', 'vendor/**/*.pp', 'spec/**/*.pp', 'pkg/**/*.pp']
  Dir['manifests/**/*.pp'].each do |manifest|
    sh "puppet parser validate --noop #{manifest}"
  end
  Dir['templates/**/*.erb'].each do |template|
    sh "erb -P -x -T '-' #{template} | ruby -c"
  end
end

Rake::Task[:spec_standalone].clear
desc 'Run spec tests on an existing fixtures directory (for Puppet code)'
RSpec::Core::RakeTask.new(:spec_puppet) do |t|
  PuppetLint.configuration.ignore_paths = ['dev/**/*.pp', 'vendor/**/*.pp', 'spec/**/*.pp', 'pkg/**/*.pp']
  t.rspec_opts = ['--color --order rand']
  t.pattern = 'spec/{classes,defines}/**/*_spec.rb'
end
desc 'Run spec tests on an existing fixtures directory (for Ruby code)'
RSpec::Core::RakeTask.new(:spec_ruby) do |t|
  PuppetLint.configuration.ignore_paths = ['dev/**/*.pp', 'vendor/**/*.pp', 'spec/**/*.pp', 'pkg/**/*.pp']
  t.rspec_opts = ['--color --order rand']
  t.verbose = true
  t.pattern = 'spec/{unit,functions,hosts,integration,types}/**/*_spec.rb'
end
desc 'Run spec tests on an existing fixtures directory'
task spec_standalone: [
  :spec_puppet,
  :spec_ruby
]

task spec_puppet_prepared: [
  :spec_prep,
  :spec_puppet
]

begin
  require 'beaker'
  desc 'Run acceptance tests'
  RSpec::Core::RakeTask.new(:acceptance) do |t|
    t.pattern = 'spec/acceptance'
  end
rescue LoadError
  task :acceptance do
    $stderr.puts 'Beaker is not avialable, skipping acceptance tests'
  end
end

desc 'Clean fixtures'
task :clean_fixtures do
  FileUtils.rmtree 'spec/fixtures/modules'
end

desc 'Run syntax, lint, and spec tests.'
task test: [
  :metadata_lint,
  :lint,
  :validate,
  :clean_fixtures,
  :spec
]
PuppetLint.configuration.send('disable_documentation')
PuppetLint.configuration.send('disable_single_quote_string_with_variables')
PuppetLint.configuration.ignore_paths = ['dev/**/*.pp', 'vendor/**/*.pp', 'spec/**/*.pp', 'pkg/**/*.pp']

Bundler::Audit::Task.new

task default: 'bundle:audit'

desc 'Runs RuboCop'
task :rubocop do
  RuboCop::RakeTask.new
end
