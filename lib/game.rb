# frozen_string_literal: true

require './lib/board'
require 'pry-byebug'

class Game
  def initialize(player1, player2)
    @players = [player1, player2]
    @current_player = @players.sample
    @board = Board.new
  end

  def player_turn
    puts "It's #{@current_player.name}'s turn."
    loop do
      input = verify_input(player_input)
      break unless input.nil?

      puts 'Invalid input. Please pick a column between 1 and 7'
    end
    switch_current_player
  end

  def player_input
    puts 'Pick the column you wanna drop a disc in ( From 1 to 7 )'
    gets.chomp
  end

  def verify_input(input)
    return input if input.match(/^[1-7]$/)
  end

  def switch_current_player
    @current_player = @players.find { |player| player != @current_player }
  end

  def over?
    return false if @board.last_disc.nil?

    horizontal_connect_four? || vertical_connect_four? || positive_slope_diagonal_connect_four? || negative_slope_diagonal_connect_four?
  end

  private

  # These methods start their checks from the last disc that was pushed, as that is the disc that must have caused the connect four
  def horizontal_connect_four?
    last_disc = @board.last_disc
    row_to_check = @board.row(last_disc.row_index)
    connected_discs = []
    # Add discs to the right of last disc until different disc, empty cell or board edge is hit
    current_disc = row_to_check[last_disc.column_index + 1]
    until current_disc != last_disc
      connected_discs << current_disc
      current_disc = row_to_check[current_disc.column_index + 1]
    end
    # Add discs to the left of last disc until different disc, empty cell or board edge is hit
    current_disc = row_to_check[last_disc.column_index - 1]
    until current_disc != last_disc
      connected_discs << current_disc
      current_disc = row_to_check[current_disc.column_index - 1]
    end
    # Add last disc
    connected_discs << last_disc
    connected_discs.length == 4
  end

  def vertical_connect_four?
    last_disc = @board.last_disc
    column_to_check = @board.column(last_disc.column_index)
    connected_discs = []
    # Add discs above last disc until different disc, empty cell or board edge is hit
    current_disc = column_to_check[last_disc.row_index + 1]
    until current_disc != last_disc
      connected_discs << current_disc
      current_disc = column_to_check[current_disc.row_index + 1]
    end
    # Add discs to the left of last disc until different disc, empty cell or board edge is hit
    current_disc = column_to_check[last_disc.row_index - 1]
    until current_disc != last_disc
      connected_discs << current_disc
      current_disc = column_to_check[current_disc.row_index - 1]
    end
    # Add last disc
    connected_discs << last_disc
    connected_discs.length == 4
  end

  def positive_slope_diagonal_connect_four?
    last_disc = @board.last_disc
    connected_discs = []
    # Add discs diagonally above until different disc, empty cell or board edge is hit
    current_disc = @board.column(last_disc.column_index + 1)[last_disc.row_index + 1]
    until current_disc != last_disc
      connected_discs << current_disc
      current_disc = @board.column(current_disc.column_index + 1)[current_disc.row_index + 1]
    end
    # Add discs diagonally below until different disc, empty cell or board edge is hit
    current_disc = @board.column(last_disc.column_index - 1)[last_disc.row_index - 1]
    until current_disc != last_disc
      connected_discs << current_disc
      current_disc = @board.column(current_disc.column_index - 1)[current_disc.row_index - 1]
    end
    # Add last disc
    connected_discs << last_disc
    connected_discs.length == 4
  end

  def negative_slope_diagonal_connect_four?
    last_disc = @board.last_disc
    connected_discs = []
    # Add discs diagonally below until different disc, empty cell or board edge is hit
    current_disc = @board.column(last_disc.column_index + 1)[last_disc.row_index - 1]
    until current_disc != last_disc
      connected_discs << current_disc
      current_disc = @board.column(current_disc.column_index + 1)[current_disc.row_index - 1]
    end
    # Add discs diagonally above until different disc, empty cell or board edge is hit
    current_disc = @board.column(last_disc.column_index - 1)[last_disc.row_index + 1]
    until current_disc != last_disc
      connected_discs << current_disc
      current_disc = @board.column(current_disc.column_index - 1)[current_disc.row_index + 1]
    end
    # Add last disc
    connected_discs << last_disc
    connected_discs.length == 4
  end
end
