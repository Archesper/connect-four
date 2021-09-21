# frozen_string_literal: false

require './lib/tokens'

class Board
  def initialize
    @columns = Array.new(7) { Array.new(6) }
  end

  def push_disc(column_index, disc)
    column = @columns[column_index - 1]
    if column.count(nil).zero?
      nil
    else
      first_free_index = column.find_index(nil)
      column[first_free_index] = disc
    end
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
