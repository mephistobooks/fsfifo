require 'simplecov'
require 'simplecov-rcov'
SimpleCov.start if ENV["COVERAGE"]  # to do this, type COVERAGE=true rake test

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
# require 'test-unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
# $stdout.puts "LOAD_PATH (size: #{$LOAD_PATH.size}): #{$LOAD_PATH}"
require 'fsfifo'
require 'test-unit'

class Test::Unit::TestCase
end
