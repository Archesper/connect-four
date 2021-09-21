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
end