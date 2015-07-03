require 'rake'
require 'rake/testtask'
require 'rcov/rcovtask'

# Understands the confirmation of behavior for the application
namespace :test do

  Rake::TestTask.new('unit') do |t|
    t.pattern = 'test/unit/*_test.rb'
    t.verbose = true
  end

  Rcov::RcovTask.new do |t|
    t.pattern = FileList['test/unit/*_test.rb']
    t.verbose = true
    t.output_dir = 'test/coverage'
  end
  
end

desc "Run all Blackjack tests"
Rake::Task[:test].prerequisites << 'test:unit'

task :default => ['test:rcov']
