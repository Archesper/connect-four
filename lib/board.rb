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
    5.downto(0) do |index|
      @columns.each do |column|
        cell = column[index].nil? ? Tokens::EMPTY : column[index]
        representation << " #{cell}"
      end
      representation << "\n"
    end
    representation
  end
end
