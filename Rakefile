# encoding: utf-8
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require File.join(File.dirname(__FILE__), 'lib', 'active_presenter', 'version')

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the active_presenter plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the active_presenter plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'ActivePresenter'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "active_presenter"
    gemspec.version = ActivePresenter::Version::STRING
    gemspec.summary = "ActivePresenter is the presenter library"
    gemspec.description = "ActivePresenter is the presenter library you already know! (...if you know ActiveRecord)"
    gemspec.email = "james@giraffesoft.ca"
    gemspec.homepage = "git://github.com/galetahub/freeberry.git"
    gemspec.authors = ["James Golick", "Daniel Haran", "Igor Galeta"]
    gemspec.files = FileList["[A-Z]*", "{lib}/**/*"]
    gemspec.rubyforge_project = "active_presenter"
  end
  
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end
