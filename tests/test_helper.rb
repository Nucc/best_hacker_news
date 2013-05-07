require 'minitest/autorun'

class MiniTest::Spec

  # Flush the redis database before each test run
  def setup
    @redis = Redis.new
    @redis.flushall
  end
end