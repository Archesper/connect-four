# frozen_string_literal: true

class Player
  attr_reader :name, :disc

  def initialize(name, disc)
    @name = name
    @disc = disc
  end
end
