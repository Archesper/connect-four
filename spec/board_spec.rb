# frozen_string_literal: true

require './lib/board'
require './lib/disc'

describe Board do
  subject(:board) { described_class.new }
  describe '#push_disc' do
    let(:disc) { instance_double(Disc) }
    before do
      allow(Disc).to receive(:new).and_return(disc)
    end
    context 'when targetted column is empty' do
      it 'pushes disc to the bottom of the column' do
        expect { board.push_disc(1, 'dummy') }.to change { board.instance_variable_get(:@columns)[0] }.to [disc, nil, nil, nil, nil, nil]
      end
    end

    context 'when targetted column is not empty' do
      it 'pushes disc to the first free cell of the board' do
        board.instance_variable_get(:@columns)[2] = [disc, disc, nil, nil, nil, nil]
        expect { board.push_disc(3, 'dummy') }.to change { board.instance_variable_get(:@columns)[2] }.to [disc, disc, disc, nil, nil, nil]
      end
    end

    context 'when targetted column is full' do
      it 'returns nil' do
        board.instance_variable_get(:@columns)[4] = [disc, disc, disc, disc, disc, disc]
        expect(board.push_disc(5, 'dummy')).to be_nil
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
