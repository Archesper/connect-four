# frozen_string_literal: true

class Player
  attr_reader :name, :token, :color

  def initialize(name, token, color)
    @name = name
    @token = token
    @color = color
  end
end
