# frozen_string_literal: true

require './lib/board'

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
    puts 'Pick the column you wanna drop a disk in ( From 1 to 7 )'
    gets.chomp
  end

  def verify_input(input)
    return input if input.match(/^[1-7]$/)
  end

  def switch_current_player
    @current_player = @players.find { |player| player != @current_player }
  end
end
