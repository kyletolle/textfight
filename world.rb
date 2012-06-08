require './cell'

class World
  
  def self.instance
    @instance ||= World.new
    @instance
  end

  # Places the user on the map
  def join(fighter)
    @fighters << fighter

    place_user(fighter)
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

  def up(fighter)
    row, col = locate(fighter) 
    old_cell = @grid[row][col]
    old_cell.remove(fighter)

    new_cell = @grid[((row-1)+10)%10][col]
    new_cell.hold(fighter)

    push_map
  end

  def down(fighter)

    push_map
  end

  def left(fighter)

    push_map
  end

  def right(fighter)

    push_map
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

    def place_user(fighter)
      cell = starting_cell
      cell.hold(fighter)

      push_map
    end

    def starting_cell
      row, col = @start_coords.pop
      cell = @grid[row][col]
    end
  
    def push_map
      @fighters.each do |fighter|
        fighter.connection.puts "\n\n\n\n\n\n\n\n\n\n"
        fighter.connection.puts map
      end
    end

    def locate(fighter)
      @grid.each.with_index do |row, row_num|
        row.each.with_index do |cell, col_num|
          if cell.holds?(fighter)
            return row_num, col_num
          end
        end
      end
      return nil,nil
    end
end

