require './cell'

class World
  
  def self.instance
    @instance ||= World.new
    @instance
  end

  # Places the user on the map
  def join(fighter)
    @fighters << fighter
    coords = @start_coords.pop
    @grid[coords[0]][coords[1]].hold(fighter)
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

    Dimension = 10

    def initialize
      @fighters ||= []
      @start_coords = [[0,0], [9,9]]
      create_world
    end

    def create_world
      create_grid
    end

    def create_grid
      @grid = []
      Dimension.times do
        row = []
        Dimension.times { row << Cell.new }
        @grid << row
      end
    end
end

