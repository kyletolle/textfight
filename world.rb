require './cell'

class World
  
  def self.instance
    @instance ||= World.new
    @instance
  end

  # Asks the user whether they're ready to start the battle
  def join(fighter)
  end

  # Returns string of the state of the world.
  def map

    state_text = ""

    @grid.each.with_index do |row, row_num|
      row.each.with_index do |cell, col_num|
        state_text += " #{cell} "
        state_text += "|" if col_num < 9
      end
      state_text << "\n---------------------------------------\n" if row_num < 9
    end

    state_text
  end

  private

    World_Dimension = 10

    def initialize
      @accepted ||= []
      create_world
    end

    def create_world
      create_grid
    end

    def create_grid
      @grid = []
      10.times do
        row = []
        10.times { row << Cell.new }
        @grid << row
      end
    end
end

