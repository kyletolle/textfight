require './battle'

# From http://c2.com/cgi/wiki?RubySingleton
module ThreadSafeSingleton
  def self.append_features(clazz)
    require 'thread'
      clazz.module_eval { 
      private_class_method :new
      @instance_mutex = Mutex.new
      def self.instance 
        @instance_mutex.synchronize {
          @instance = new unless @instance
          @instance
        }
      end

      def self.reset
        @instance_mutex.synchronize {
          @instance = nil
        }
      end
    }
  end
end

# Represents the world the fighters see.
class World
  include ThreadSafeSingleton
  
  class FightFinished < StandardError; end

  # Places the user on the map.
  def join(fighter)
    fighter_number = @fighters.size

    @fighters << fighter

    fighter_number
  end

  # Return a pair of starting coordinates.
  def starting_location!
    @start_coords.pop
  end

  # Perform actions when notified a fighter has moved.
  def fighter_moved
    render

    if fighters_in_same_cell?
      Battle.new @fighters
      
      # Battle is finished, so disconnect the fighters.
      raise FightFinished
    end
  end

  # Render the world to each of the fighters.
  def render
    push_map
  end

  private

    Dimension = 10
    Min_Coord = 0
    Max_Coord = Dimension-1

    # Set up the world.
    def initialize
      @fighters ||= []
      @start_coords = starting_points
    end

    def starting_points
      random_starting_points
    end

    def random_starting_points
      points = []
      2.times do |index|
        # Makes sure users don't start at the same point.
        begin
          point = rand_point
        end while points.include? point

        points[index] = point
      end
      points
    end

    def rand_point
      [rand_coord, rand_coord]
    end

    def rand_coord
      rand Dimension
    end

    # Returns string of the state of the world.
    def map
      state_text = ""

      # Get the user info string
      fighter_text = "Players: "
      @fighters.each.with_index do |fighter, index|
        fighter_text += "##{index}: #{fighter.name}"
        fighter_text += ",  " if index == 0
      end
      state_text += fighter_text + "\n"

      # Loop over each cell
      Dimension.times do |x|
        Dimension.times do |y|
          # Render the text for the cell
          state_text += " #{render_cell x,y} "

          # Border between cells.
          state_text += "|" if y < Max_Coord
        end

        # Separator text between rows
        state_text << row_sep if x < Max_Coord
      end

      state_text
    end

    # Returns a row separator string.
    def row_sep
      text = "\n"
      39.times { text += "-" }
      text += "\n"
    end

    # Push the map to each of the fighters.
    def push_map
      @fighters.each do |fighter|
        fighter.connection.puts blank_lines
        fighter.connection.puts map
      end
    end

    # Returns multiple newlines.
    def blank_lines
      blank_lines = ""
      15.times { blank_lines += "\n" }
      blank_lines
    end

    # Returns a character representation of the given cell.
    def render_cell(x,y)
      case num_fighters_in_cell x,y
      # Two fighters in the cell, so we display a !.
      when 2
        "!"

      # One fighter in the cell.
      when 1
        fighter_icon_at x,y

      # No fighters, so this is a blank cell.
      when 0
        " "
      end
    end

    # Gets the icon for the fighter in a given cell.
    def fighter_icon_at(x, y)
      fighter_in_cell =
        @fighters.select {|fighter| fighter.located_here?(x, y)}.first

      fighter_in_cell.icon
    end

    # Returns the number of fighters in a given cell.
    def num_fighters_in_cell(x,y)
      count = 0

      @fighters.each do |fighter|
        count +=1 if fighter.located_here? x, y
      end

      count
    end

    def fighters_in_same_cell?
      @fighters[0].location == @fighters[1].location
    end
end

