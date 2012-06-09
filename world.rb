class World
  
  def self.instance
    @instance ||= World.new
    @instance
  end

  # Places the user on the map
  def join(fighter)
    @fighters << fighter

    push_map
  end

  def starting_location!
    @start_coords.pop
  end

  def fighter_moved
    push_map
  end

  private

    Dimension = 10

    def initialize
      @fighters ||= []
      @start_coords = [[0,0], [9,9]]
    end

    # Returns string of the state of the world.
    def map
      state_text = ""

      Dimension.times do |x|
        Dimension.times do |y|
          state_text += " #{render_cell(x,y)} "

          # Border between cells
          state_text += "|" if y < 9
        end

        # Spacer text between rows
        state_text << "\n---------------------------------------\n" if x < 9
      end

      state_text
    end

    def push_map
      @fighters.each do |fighter|
        fighter.connection.puts "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
        fighter.connection.puts map
      end
    end

    def render_cell(x,y)
      case num_fighters_in_cell(x,y)
      # Two fighters in the cell, so we display a !.
      when 2
        "!"

      # One fighter in the cell.
      when 1
        fighter_icon_at(x,y)

      # No fighters, so this is a blank cell.
      when 0
        " "
      end
    end

    def fighter_icon_at(x, y)
      fighter_in_cell =
        @fighters.select {|fighter| fighter.located_here?(x, y)}.first

      fighter_in_cell.icon
    end

    def num_fighters_in_cell(x,y)
      count = 0

      @fighters.each do |fighter|
        count +=1 if fighter.located_here?(x, y)
      end

      count
    end
end

