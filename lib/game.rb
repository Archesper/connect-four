# frozen_string_literal: true

require './lib/board'
require './lib/player'

class Game
  def initialize(player1, player2)
    @players = [player1, player2]
    @current_player = @players.sample
    @board = Board.new
  end

  def player_turn
    puts "It's #{Display.colorize(@current_player.name, @current_player.color)}'s turn."
    input = nil
    loop do
      input = verify_input(player_input)
      break unless input.nil? || input == :full

      input.nil? ? puts("\e[33mInvalid input. Please pick a column between 1 and 7.\e[m") : puts("\e[33mTargetted column is full, please pick another.\e[m")
    end
    update_board(input)
    switch_current_player
  end

  def play
    until over?
      puts @board
      player_turn
    end
    puts board
    puts finish_message
  end

  def update_board(input)
    @board.push_disc(input.to_i, @current_player.token)
  end

  def verify_input(input)
    return unless input.match(/^[1-7]$/)
    return :full if @board.column(input.to_i - 1).count(nil).zero?

    input
  end

  def switch_current_player
    @current_player = @players.find { |player| player != @current_player }
  end

  def over?
    return false if @board.last_disc.nil?

    horizontal_connect_four? || vertical_connect_four? || positive_slope_diagonal_connect_four? || negative_slope_diagonal_connect_four? || @board.count_disc(nil).zero?
  end

  def finish_message
    if @board.count_disc(nil).zero?
      "Game over! It's a tie."
    else
      # Switch @current_player as player is switched before over? check
      switch_current_player
      "Game over! #{Display.colorize(@current_player.name, @current_player.color)} won!"
    end
  end

  def self.game_setup
    names = player_names
    red_player = Player.new(names[:red], Display::RED_DISC, :red)
    yellow_player = Player.new(names[:yellow], Display::YELLOW_DISC, :yellow)
    new(red_player, yellow_player)
  end

  private

  # These methods start their checks from the last disc that was pushed, as that is the disc that must have caused the connect four
  def horizontal_connect_four?
    last_disc = @board.last_disc
    connected_discs = []
    # Add discs to the right of last disc until different disc, empty cell or board edge is hit
    current_disc = @board.get_disc(last_disc.column_index + 1, last_disc.row_index)
    until current_disc != last_disc
      connected_discs << current_disc
      current_disc = @board.get_disc(current_disc.column_index + 1, current_disc.row_index)
    end
    # Add discs to the left of last disc until different disc, empty cell or board edge is hit
    current_disc = @board.get_disc(last_disc.column_index - 1, last_disc.row_index)
    until current_disc != last_disc
      connected_discs << current_disc
      current_disc = @board.get_disc(current_disc.column_index - 1, current_disc.row_index)
    end
    # Add last disc
    connected_discs << last_disc
    connected_discs.length == 4
  end

  def vertical_connect_four?
    last_disc = @board.last_disc
    connected_discs = []
    # Add discs above last disc until different disc, empty cell or board edge is hit
    current_disc = @board.get_disc(last_disc.column_index, last_disc.row_index + 1)
    until current_disc != last_disc
      connected_discs << current_disc
      current_disc = @board.get_disc(current_disc.column_index, current_disc.row_index + 1)
    end
    # Add discs to the left of last disc until different disc, empty cell or board edge is hit
    current_disc = @board.get_disc(last_disc.column_index, last_disc.row_index - 1)
    until current_disc != last_disc
      connected_discs << current_disc
      current_disc = @board.get_disc(current_disc.column_index, current_disc.row_index - 1)
    end
    # Add last disc
    connected_discs << last_disc
    connected_discs.length == 4
  end

  def positive_slope_diagonal_connect_four?
    last_disc = @board.last_disc
    connected_discs = []
    # Add discs diagonally above until different disc, empty cell or board edge is hit
    current_disc = @board.get_disc(last_disc.column_index + 1, last_disc.row_index + 1)
    until current_disc != last_disc
      connected_discs << current_disc
      current_disc = @board.get_disc(current_disc.column_index + 1, current_disc.row_index + 1)
    end
    # Add discs diagonally below until different disc, empty cell or board edge is hit
    current_disc = @board.get_disc(last_disc.column_index - 1, last_disc.row_index - 1)
    until current_disc != last_disc
      connected_discs << current_disc
      current_disc = @board.get_disc(current_disc.column_index - 1, current_disc.row_index - 1)
    end
    # Add last disc
    connected_discs << last_disc
    connected_discs.length == 4
  end

  def negative_slope_diagonal_connect_four?
    last_disc = @board.last_disc
    connected_discs = []
    # Add discs diagonally below until different disc, empty cell or board edge is hit
    current_disc = @board.get_disc(last_disc.column_index + 1, last_disc.row_index - 1)
    until current_disc != last_disc
      connected_discs << current_disc
      current_disc = @board.get_disc(current_disc.column_index + 1, current_disc.row_index - 1)
    end
    # Add discs diagonally above until different disc, empty cell or board edge is hit
    current_disc = @board.get_disc(last_disc.column_index - 1, last_disc.row_index + 1)
    until current_disc != last_disc
      connected_discs << current_disc
      current_disc = @board.get_disc(current_disc.column_index - 1, current_disc.row_index + 1)
    end
    # Add last disc
    connected_discs << last_disc
    connected_discs.length == 4
  end

  def player_input
    puts 'Pick the column you wanna drop a disc in. ( From 1 to 7 )'
    gets.chomp
  end

  def self.player_names
    puts "Please input players' names:"
    print "\e[31mRed player's\e[m name: "
    red_player_name = gets.chomp
    print "\e[93mYellow player's\e[m name: "
    yellow_player_name = gets.chomp
    { red: red_player_name, yellow: yellow_player_name }
  end
  private_class_method :player_names
end

class GameAgainstComputer < Game
  def initialize(human_token, computer_token)
    @board = Board.new
    @human_token = human_token
    @computer_token = computer_token
  end

  def self.game_setup
    puts 'Would you rather play with red disc or the yellow disc? (Input red, yellow, R, Y)'
    color = gets.chomp.downcase
    until %w[red r yellow y].include? color
      puts "\e[33mPlease pick one of the specified colors. (red, yellow, R, Y)\e[m"
      color = gets.chomp.downcase
    end
    case color
    when 'red', 'r'
      human_token = Display::RED_DISC
      computer_token = Display::YELLOW_DISC
    when 'yellow', 'y'
      human_token = Display::YELLOW_DISC
      computer_token = Display::RED_DISC
    end
    new(human_token, computer_token)
  end

  def play
    turn = 0
    until over?
      puts @board
      turn.even? ? player_turn : computer_turn
      turn += 1
    end
    puts @board
    puts finish_message
  end

  def player_turn
    puts "It's your turn!"
    input = nil
    loop do
      input = verify_input(player_input)
      break unless input.nil? || input == :full

      input.nil? ? puts("\e[33mInvalid input. Please pick a column between 1 and 7.\e[m") : puts("\e[33mTargetted column is full, please pick another.\e[m")
    end
    update_board(input)
  end

  def computer_turn
    puts "It's the computer's turn."
    column_to_push_to = @board.non_full_columns.sample
    @board.push_disc(column_to_push_to, @computer_token)
  end

  def update_board(input)
    @board.push_disc(input.to_i, @human_token)
  end

  def finish_message
    if @board.count_disc(nil).zero?
      "Game over! It's a tie."
    elsif @human_token == @board.last_disc.token
      "\e[92mGame over! You win!\e[m"
    else
      "\e[33mGame over! Computer wins.\e[m"
    end
  end
end
