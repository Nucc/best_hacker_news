require 'redis'

class Leaderboard

  attr_accessor :name

  def initialize(name)
    @name = name
  end

end
