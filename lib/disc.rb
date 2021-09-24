class Disc
  attr_reader :token, :row_index, :column_index

  def initialize(token, row, column)
    @token = token
    @row_index = row
    @column_index = column
  end

  def ==(other)
    return false unless other.instance_of?(Disc)

    token == other.token
  end
end
