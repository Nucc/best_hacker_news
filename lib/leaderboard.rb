require 'redis'

class Leaderboard

  attr_accessor :name

  def initialize(name)
    @name = name
    @redis = Redis.new
  end

  def []=(user_id, score)
    @redis.zadd(@name, score, user_id)
  end

  def [](user)
    @redis.zscore(@name, user)
  end

  def rank(user)
    @redis.zrevrank(@name, user) + 1
  end
end
