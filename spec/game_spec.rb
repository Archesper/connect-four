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
  end
end
