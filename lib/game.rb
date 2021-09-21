# frozen_string_literal: true

require './lib/board'

class Game
  def initialize(player1, player2)
    @players = [player1, player2]
    @board = Board.new
  end

  def verify_input(input)
    return input if input.match(/^[1-7]$/)
  end

  def current_player
    player_disc_counts = @players.map { |player| @board.count_disc(player.disc) }
    if player_disc_counts[0] > player_disc_counts[1]
      @players[1]
    elsif player_disc_counts[0] < player_disc_counts[1]
      @players[0]
    end
  end
end
