# frozen_string_literal: false

require './lib/display'
require './lib/disc'

class Board
  attr_reader :last_disc

  def initialize
    @columns = Array.new(7) { Array.new(6) }
    # Instance variable to keep track of last pushed disc, to be used in determining whether game is over
    @last_disc = nil
  end

  def push_disc(column_index, token)
    column = @columns[column_index - 1]
    if column.count(nil).zero?
      nil
    else
      first_free_index = column.find_index(nil)
      new_disc = Disc.new(token, first_free_index, column_index - 1)
      @last_disc = new_disc
      column[first_free_index] = new_disc
    end
  end

  def get_disc(column_index, row_index)
    # Return nil if either indexes are negative
    # This check is necessary, as if a negative index is used array indexing will start at the end
    # which might return a disc, when the behavior that should be simulated is 'going off the board'
    # and returning a node that doesn't exist i.e nil
    return nil unless column_index >= 0 && row_index >= 0

    column = @columns[column_index]
    return nil if column.nil?

    column[row_index]
  end

  def count_disc(disc)
    @columns.inject(0) { |total, column| total + column.count(disc) }
  end

  def row(index)
    @columns.map { |column| column[index] }
  end

  def column(index)
    @columns[index]
  end

  def non_full_columns
    indexes = []
    @columns.each_with_index do |column, index|
      indexes << index + 1 unless column.count(nil).zero?
    end
    indexes
  end

  def to_s
    representation = ''
    representation << Display::TOP_BOX_FRAME
    5.downto(0) do |row_index|
      @columns.each_with_index do |column, column_index|
        representation << " #{Display::VERTICAL_LINE}" if column_index.zero?
        cell = column[row_index].nil? ? Display::EMPTY_CELL : column[row_index].token
        representation << " #{cell}"
        representation << " #{Display::VERTICAL_LINE}" if column_index == @columns.length - 1
      end
      representation << "\n"
    end
    representation << Display::BOTTOM_BOX_FRAME
    representation
  end
end
