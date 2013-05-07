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

  def median
    entry = @redis.zrange(@name, count/2, count/2, {:withscores => true})[0][1]
  end

  def mean
    scores = @redis.zrange(@name, 0, count, {withscores: true})

    sum = 0
    scores.each { |x| sum += x[1] }
    sum / count.to_f
  end

  def count
    @redis.zcount(@name, "-inf", "+inf")
  end

end
