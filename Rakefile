# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "fsfifo"
  gem.homepage = "http://github.com/mephistobooks/fsfifo"
  gem.license = "MIT"
  gem.summary = %Q{Fixed size FIFO.}
  gem.description = %Q{Fixed size FIFO, LIFO, and Array.}
  gem.email = "martin.route66.blues+github@gmail.com"
  gem.authors = ["YAMAMOTO, Masayuki"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

# $stderr.puts "LOAD_PATH in Rakefile (size: #{$LOAD_PATH.size}): #{$LOAD_PATH}"
require 'rake/testtask'
require 'test-unit'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  #test.pattern = 'test/**/test_*.rb'
  test.pattern = 'test/**/test*.rb'
  test.verbose = true
end

#require 'rcov/rcovtask'
#Rcov::RcovTask.new do |test|
#  test.libs << 'test'
#  test.pattern = 'test/**/test_*.rb'
#  test.verbose = true
#  test.rcov_opts << '--exclude "gems/*"'
#end
#require 'simplecov'
#require 'simplecov-rcov'
#SimpleCov.start if ENV["COVERAGE"]  # to do this, type COVERAGE=true rake test

task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "fsfifo #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
