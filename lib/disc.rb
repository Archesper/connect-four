class Disc
  attr_reader :token, :row_index, :column_index

  def initialize(token, row, column)
    @token = token
    @row_index = row
    @column_index = column
  end

  def ==(other)
    token == other.token
  end
end