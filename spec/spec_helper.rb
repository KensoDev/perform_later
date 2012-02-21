require "perform_later"
require "rspec"
require "support/database_connection"
require "support/database_models"
require "redis"

RSpec.configure do |config|
  config.mock_with :rspec

  config.after(:each) do
    $redis.flushdb
  end

  config.before(:all) do
    dir = File.join(File.dirname(__FILE__), 'support/db')
    
    old_db = File.join(dir, 'test.sqlite3')
    FileUtils.rm(old_db) if File.exists?(old_db)
    FileUtils.cp(File.join(dir, '.blank.sqlite3'), File.join(dir, 'test.sqlite3'))
  end

  root = File.dirname(__FILE__)
  REDIS_PID = File.join(root, "tmp/pids/redis-test.pid")
  REDIS_CACHE_PATH = File.join(root, "tmp/cache/")

  FileUtils.mkdir_p File.join(root, "tmp/pids")
  FileUtils.mkdir_p File.join(root, "tmp/cache")

  config.before(:suite) do
    redis_options = {
      "daemonize"     => 'yes',
      "pidfile"       => REDIS_PID,
      "port"          => 9726,
      "timeout"       => 300,
      "save 900"      => 1,
      "save 300"      => 1,
      "save 60"       => 10000,
      "dbfilename"    => "dump.rdb",
      "dir"           => REDIS_CACHE_PATH,
      "loglevel"      => "debug",
      "logfile"       => "stdout",
      "databases"     => 16
    }.map { |k, v| "#{k} #{v}" }.join('\n')
    cmd = "echo '#{redis_options}' | redis-server -"
    system cmd
    
    
    uri = URI.parse("http://localhost:9726")
    $redis = Redis.new(host: uri.host, port: uri.port)
  end
    
  config.after(:suite) do
    %x{
      cat #{REDIS_PID} | xargs kill -QUIT
      rm -f #{REDIS_CACHE_PATH}dump.rdb
      rm -f #{REDIS_PID}
    }
  end
end