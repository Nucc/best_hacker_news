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
    sum = 0
    all_with_scores.each { |x| sum += x[1] }
    sum / count.to_f
  end

  def mode
    bag = {}
    @redis.zrangebyscore(@name, "-inf", "+inf", {withscores: true}).each do |value|
      name, score = value
      bag[score] ||= 0
      bag[score] += 1
    end
    bag.sort_by { |number, count| count }.last[0]
  end

  def count
    @redis.zcount(@name, "-inf", "+inf")
  end

private

  def all_with_scores
    @redis.zrange(@name, 0, count, {withscores: true})
  end

end
