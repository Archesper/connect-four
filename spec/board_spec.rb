# frozen_string_literal: true

require './lib/board'

describe Board do
  subject(:board) { described_class.new }
  describe '#push_disc' do
    context 'when targetted column is empty' do
      it 'pushes disc to the bottom of the column' do
        disc = 'dummy disc'
        expect { board.push_disc(1, disc) }.to change { board.instance_variable_get(:@columns)[0] }.to ['dummy disc', nil, nil, nil, nil, nil]
      end
    end

    context 'when targetted column is not empty' do
      it 'pushes disc to the first free cell of the board' do
        disc = 'dummy disc'
        board.instance_variable_get(:@columns)[2] = [disc, disc, nil, nil, nil, nil]
        expect { board.push_disc(3, disc) }.to change { board.instance_variable_get(:@columns)[2] }.to [disc, disc, disc, nil, nil, nil]
      end
    end

    context 'when targetted column is full' do
      it 'returns nil' do
        disc = 'dummy disc'
        board.instance_variable_get(:@columns)[4] = [disc, disc, disc, disc, disc, disc]
        expect(board.push_disc(5, disc)).to be_nil
      end
    end
  end

  describe '#count_disc' do
    context 'when there are no DUMMY discs' do
      it 'returns 0' do
        disc = 'DUMMY'
        count = board.count_disc(disc)
        expect(count).to be_zero
      end
    end

    context 'when there are 4 DUMMY discs' do
      it 'returns 4' do
        disc = 'DUMMY'
        count = board.count_disc(disc)
        expect(count).to be_zero
      end
    end
  end
end
