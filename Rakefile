require 'rake'
require 'rdoc/task'
require File.dirname(__FILE__)+'/lib/active_presenter'
Dir.glob(File.dirname(__FILE__)+'/lib/tasks/**/*.rake').each { |l| load l }

task :default => :test

task :test do
  Dir['test/**/*_test.rb'].each { |l| require File.join(File.dirname(__FILE__),l)}
end
