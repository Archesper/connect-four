# frozen_string_literal: true

require './lib/game'
require './lib/player'

describe Game do
  subject(:game) { Game.new(player1, player2) }
  let(:player1) { instance_double(Player, name: '1', disc: 'dummy 1') }
  let(:player2) { instance_double(Player, name: '2', disc: 'dummy 2') }

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

    context 'when user input is valid' do
      before do
        valid_input = '5'
        allow(game).to receive(:player_input).and_return(valid_input)
        allow(game).to receive(:puts)
        allow(game).to receive(:switch_current_player)
      end
      it 'breaks loop without displaying error message then switches current player' do
        expect(game).to receive(:puts).once
        expect(game).to receive(:switch_current_player).once
        game.player_turn
      end
    end

    context 'when user inputs an invalid value 2 times then a valid value' do
      before do
        game.instance_variable_set(:@current_player, player1)
        letter = 'a'
        large_number = '170'
        valid_input = '5'
        allow(game).to receive(:player_input).and_return(letter, large_number, valid_input)
        allow(game).to receive(:puts)
        allow(game).to receive(:switch_current_player)
      end
      it 'outputs error message twice before breaking loop, then switches current player' do
        turn_message = "It's #{game.instance_variable_get(:@current_player).name}'s turn."
        expect(game).to receive(:puts).with(turn_message).once
        expect(game).to receive(:puts).with(error_message).twice
        expect(game).to receive(:switch_current_player).once
        game.player_turn
      end
    end
  end
end
