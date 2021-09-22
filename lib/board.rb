# frozen_string_literal: false

require './lib/display'

class Board
  attr_reader :last_disc_coordinates

  def initialize
    @columns = Array.new(7) { Array.new(6) }
    # Instance variable to keep track of last pushed disc, to be used in determining whether game is over
    @last_disc_coordinates = nil
  end

  def push_disc(column_index, disc)
    column = @columns[column_index - 1]
    if column.count(nil).zero?
      nil
    else
      first_free_index = column.find_index(nil)
      @last_disc_coordinates = { row: first_free_index, column: column_index }
      column[first_free_index] = disc
    end
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

  def to_s
    representation = ''
    representation << Display::TOP_BOX_FRAME
    5.downto(0) do |row_index|
      @columns.each_with_index do |column, column_index|
        representation << " #{Display::VERTICAL_LINE}" if column_index.zero?
        cell = column[row_index].nil? ? Display::EMPTY_CELL : column[row_index]
        representation << " #{cell}"
        representation << "  #{Display::VERTICAL_LINE}" if column_index == @columns.length - 1
      end
      representation << "\n"
    end
    representation << Display::BOTTOM_BOX_FRAME
    representation
  end
end
