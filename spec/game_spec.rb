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

  describe '#current_player' do
    context 'when player1 has put more discs than player2' do
      before do
        allow(game.instance_variable_get(:@board)).to receive(:count_disc).with('dummy 1').and_return(7)
        allow(game.instance_variable_get(:@board)).to receive(:count_disc).with('dummy 2').and_return(5)
      end
      it 'returns player2' do
        current_player = game.current_player
        expect(current_player).to equal(player2)
      end
    end
    context 'when player1 has put less discs than player2' do
      before do
        allow(game.instance_variable_get(:@board)).to receive(:count_disc).with('dummy 1').and_return(5)
        allow(game.instance_variable_get(:@board)).to receive(:count_disc).with('dummy 2').and_return(7)
      end
      it 'returns player1' do
        current_player = game.current_player
        expect(current_player).to equal(player1)
      end
    end

    context 'at start of the game, when both players at 0 disks' do
      before do
        allow(game.instance_variable_get(:@board)).to receive(:count_disc).with('dummy 1').and_return(0)
        allow(game.instance_variable_get(:@board)).to receive(:count_disc).with('dummy 2').and_return(0)
      end
      it 'returns nil' do
        current_player = game.current_player
        expect(current_player).to be_nil
      end
    end
  end
end
