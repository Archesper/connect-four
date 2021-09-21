require './lib/board'

class Game
  def initialize(player1, player2)
    @players = [player1, player2]
    @board = Board.new
  end

  def verify_input(input)
    return input if input.match(/^[1-7]$/)
  end
end
