# frozen_string_literal: true

require_relative './lib/game'

puts "\e[34mThis is Connect Four, a game whose goal is to form a horizontal, vertical, or diagonal line by aligning 4 disks of the same color.\e[m"
puts "\e[34mDo you wanna play against another human or the computer? ( Input 1 for a human, 2 for the computer. )\e[m"
mode = gets.chomp
until %w[1 2].include? mode
  puts "\e[33mPlease pick either 1 for a human or 2 for the computer:\e[m"
  mode = gets.chomp
end
game = case mode
       when '1'
         Game.game_setup
       when '2'
         GameAgainstComputer.game_setup
       end
game.play
