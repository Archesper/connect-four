# frozen_string_literal: true

require './lib/game'
require './lib/player'
require './lib/disc'
require 'pry-byebug'

describe Game do
  subject(:game) { Game.new(player1, player2) }
  let(:player1) { instance_double(Player, name: '1', token: 'dummy 1') }
  let(:player2) { instance_double(Player, name: '2', token: 'dummy 2') }

  describe '#verify_input' do
    context 'when input is valid' do
      it 'returns input' do
        valid_input = '5'
        verified_input = game.verify_input(valid_input)
        expect(verified_input).to eql(valid_input)
      end
    end

    context 'when input is invalid it returns nil' do
      it 'returns nil for out of range numbers' do
        invalid_number = '17'
        verified_input = game.verify_input(invalid_number)
        expect(verified_input).to be_nil
      end

      it 'returns nil for symbols or letters' do
        letter = 'a'
        symbol = '$'
        verified_input1 = game.verify_input(letter)
        verified_input2 = game.verify_input(symbol)
        expect(verified_input1).to be_nil
        expect(verified_input2).to be_nil
      end
    end

    context 'when targetted column is full' do
      it 'returns :full' do
        board = game.instance_variable_get(:@board)
        allow(board).to receive(:column).with(3).and_return(['dummy'] * 6)
        full_column_index = '4'
        verified_input = game.verify_input(full_column_index)
        expect(verified_input).to eql(:full)
      end
    end
  end

  describe '#switch_current_player' do
    context 'when current player is player1' do
      it 'returns player 2' do
        game.instance_variable_set(:@current_player, player1)
        new_current_player = game.switch_current_player
        expect(new_current_player).to equal(player2)
      end
    end
    context 'when current player is player2' do
      it 'returns player 1' do
        game.instance_variable_set(:@current_player, player2)
        new_current_player = game.switch_current_player
        expect(new_current_player).to equal(player1)
      end
    end
  end

  describe '#player_turn' do
    let(:error_message) { 'Invalid input. Please pick a column between 1 and 7' }
    let(:column_full_message) { 'Targetted column is full, please pick another' }

    context 'when user input is valid' do
      before do
        valid_input = '5'
        allow(game).to receive(:player_input).and_return(valid_input)
        allow(game).to receive(:puts)
        allow(game).to receive(:update_board)
        allow(game).to receive(:switch_current_player)
      end
      it 'breaks loop without displaying error message then switches current player' do
        expect(game).to receive(:puts).once
        expect(game).to receive(:update_board).with('5').once
        expect(game).to receive(:switch_current_player).once
        game.player_turn
      end
    end

    context 'when user inputs an invalid value 2 times then a valid value' do
      before do
        letter = 'a'
        large_number = '170'
        valid_input = '5'
        allow(game).to receive(:player_input).and_return(letter, large_number, valid_input)
        allow(game).to receive(:puts)
        allow(game).to receive(:update_board)
        allow(game).to receive(:switch_current_player)
      end
      it 'outputs error message twice before breaking loop, then switches current player' do
        turn_message = "It's #{game.instance_variable_get(:@current_player).name}'s turn."
        expect(game).to receive(:puts).with(turn_message).once
        expect(game).to receive(:puts).with(error_message).twice
        expect(game).to receive(:update_board).with('5').once
        expect(game).to receive(:switch_current_player).once
        game.player_turn
      end
    end

    context 'when full column is chosen once then valid value is input' do
      before do
        board = game.instance_variable_get(:@board)
        full_column_index = '1'
        valid_input = '4'
        allow(board).to receive(:column).with(0).and_return(['dummy'] * 6)
        allow(board).to receive(:column).with(3).and_return([nil] * 6)
        allow(game).to receive(:player_input).and_return(full_column_index, valid_input)
        allow(game).to receive(:puts)
        allow(game).to receive(:update_board)
        allow(game).to receive(:switch_current_player)
      end
      it 'outputs error message once before breaking loop, then switches current player' do
        turn_message = "It's #{game.instance_variable_get(:@current_player).name}'s turn."
        expect(game).to receive(:puts).with(turn_message).once
        expect(game).to receive(:puts).with(column_full_message).once
        expect(game).to receive(:update_board).with('4').once
        expect(game).to receive(:switch_current_player).once
        game.player_turn
      end
    end
  end

  describe '#over?' do
    # Helper method for generating dummy Disc objects
    def dummy_discs(*args)
      doubles = args.map { |coordinates| instance_double(Disc, token: 'dummy', row_index: coordinates[1], column_index: coordinates[0]) }
      doubles.each do |double|
        allow(double).to receive(:==).with(having_attributes(token: 'dummy')).and_return(true)
        allow(double).to receive(:==).with(having_attributes(token: 'other dummy')).and_return(false)
      end
    end

    context 'when game is not over' do
      it 'returns false for an empty board' do
        expect(game).not_to be_over
      end
      it 'returns false for a board that is not empty, but for which the game is not over' do
        board = game.instance_variable_get(:@board)
        board_columns = board.instance_variable_get(:@columns)
        board_columns[0][0], board_columns[0][1], board_columns[0][2] = dummy_discs([0, 0], [0, 1], [0, 2])
        board.instance_variable_set(:@last_disc, board_columns[0][2])
        expect(game).not_to be_over
      end
    end

    context 'when game is over' do
      context 'when game is over by horizontal connect four' do
        it 'returns true' do
          board = game.instance_variable_get(:@board)
          board_columns = board.instance_variable_get(:@columns)
          board_columns[0][0], board_columns[1][0], board_columns[2][0], board_columns[3][0] = dummy_discs([0, 0], [1, 0], [2, 0], [3, 0])
          board.instance_variable_set(:@last_disc, board_columns[3][0])
          expect(game).to be_over
        end
        it 'returns true even if a different disc is hit' do
          board = game.instance_variable_get(:@board)
          board_columns = board.instance_variable_get(:@columns)
          different_disk = instance_double(Disc, token: 'other dummy', row_index: 0, column_index: 4)
          board_columns[0][0], board_columns[1][0], board_columns[2][0], board_columns[3][0] = dummy_discs([0, 0], [1, 0], [2, 0], [3, 0]) + [different_disk]
          board.instance_variable_set(:@last_disc, board_columns[3][0])
          expect(game).to be_over
        end
      end
      context 'when game is over by vertical connect four' do
        it 'returns true' do
          board = game.instance_variable_get(:@board)
          board_columns = board.instance_variable_get(:@columns)
          board_columns[0] = dummy_discs([0, 0], [0, 1], [0, 2], [0, 3]) + [nil, nil, nil]
          board.instance_variable_set(:@last_disc, board_columns[0][3])
          expect(game).to be_over
        end
      end
      context 'when game is over by diagonal connect four' do
        it 'returns true for a negative slope diagonal connect four' do
          board = game.instance_variable_get(:@board)
          board_columns = board.instance_variable_get(:@columns)
          board_columns[0][5], board_columns[1][4], board_columns[2][3], board_columns[3][2] = dummy_discs([0, 5], [1, 4], [2, 3], [3, 2])
          board.instance_variable_set(:@last_disc, board_columns[2][3])
          expect(game).to be_over
        end
        it 'returns true for a positive slope diagonal connect four' do
          board = game.instance_variable_get(:@board)
          board_columns = board.instance_variable_get(:@columns)
          board_columns[0][0], board_columns[1][1], board_columns[2][2], board_columns[3][3] = dummy_discs([0, 0], [1, 1], [2, 2], [3, 3])
          board.instance_variable_set(:@last_disc, board_columns[2][2])
          expect(game).to be_over
        end
      end
    end
  end
end
