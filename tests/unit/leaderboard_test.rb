require "test_helper.rb"
require "leaderboard"

class LeaderboardTest < MiniTest::Unit::TestCase

  def setup
    @board = Leaderboard.new("poker")
  end

  def test_leaderboard_must_have_name
    assert_equal "poker", @board.name
  end

  def test_set_one_entry_to_board
    @board["user1"] = 10
    assert_equal 10, @board["user1"]
  end
end