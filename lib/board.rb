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
    representation << " \u250C"
    representation << "\u2500" * 16
    representation << "\u2510"
    representation << "\n"
    5.downto(0) do |row_index|
      @columns.each_with_index do |column, column_index|
        representation << " \u2502" if column_index.zero?
        cell = column[row_index].nil? ? Tokens::EMPTY : column[row_index]
        representation << " #{cell}"
        representation << "  \u2502" if column_index == @columns.length - 1
      end
      representation << "\n"
    end
    representation << " \u2514"
    representation << "\u2500" * 16
    representation << "\u2518"
    representation
  end
end
