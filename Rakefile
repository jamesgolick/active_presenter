require 'rake'
require 'rake/rdoctask'
require File.dirname(__FILE__)+'/lib/active_presenter'
Dir.glob(File.dirname(__FILE__)+'/lib/tasks/**/*.rake').each { |l| load l }

task :default => :test

task :test do
  Dir['test/**/*_test.rb'].each { |l| require l }
end

desc 'Generate documentation for the ResourceController plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'ActivePresenter'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
