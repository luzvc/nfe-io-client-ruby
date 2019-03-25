require 'rspec'
require "vcr"
require 'byebug'
require_relative '../lib/nfe'

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.ignore_hosts '127.0.0.1', 'localhost'
  config.hook_into :webmock
end
