require "net/http"
require "uri"
require "perform_later"
require "rspec"
require "support/database_connection"
require "support/database_models"
require "redis"
require 'fakeredis/rspec'



RSpec.configure do |config|
  config.mock_with :rspec

  config.before(:all) do
    dir = File.join(File.dirname(__FILE__), 'support/db')
    
    old_db = File.join(dir, 'test.sqlite3')
    FileUtils.rm(old_db) if File.exists?(old_db)
    FileUtils.cp(File.join(dir, '.blank.sqlite3'), File.join(dir, 'test.sqlite3'))
  end

  config.before(:suite) do
    $redis = Redis.new
  end

  config.after(:each) do
    $redis.flushdb
  end
end