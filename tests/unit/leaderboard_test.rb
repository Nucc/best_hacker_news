require "test_helper.rb"
require "leaderboard"

class LeaderboardTest < MiniTest::Unit::TestCase

  def setup
    @board = Leaderboard.new("poker")

    # Flush the redis database before each test run
    @redis = Redis.new
    @redis.flushall
  end

  def test_leaderboard_must_have_name
    assert_equal "poker", @board.name
  end

  def test_register_one_user_score
    @board["user1"] = 10
    assert_equal 10, @board["user1"]
  end

  def test_rank_for_more_players
    @board["user1"] = 10
    @board["user3"] = 20
    @board["user2"] = 30

    assert_equal 1, @board.rank("user2")
    assert_equal 2, @board.rank("user3")
    assert_equal 3, @board.rank("user1")
  end

  def test_median
    @board["user1"] = 1000
    @board["user2"] = 30
    @board["user3"] = 40

    assert_equal 40, @board.median
  end

  def test_mean
    @board["user1"] = 1000
    @board["user2"] = 30
    @board["user3"] = 40

    assert_equal (1000+30+40)/3.00, @board.mean
  end

  def test_mode
    @board["user1"] = 1000
    @board["user2"] = 30
    @board["user3"] = 40
    @board["user4"] = 30
    @board["user5"] = 40
    @board["user6"] = 30

    assert_equal 30, @board.mode
  end
end