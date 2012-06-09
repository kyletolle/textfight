require './world'

class Fighter
  attr_accessor :connection, :name, :location

  def initialize(connection)
    self.connection = connection
    self.name = ask_name

    @world = World.instance
    self.location = @world.starting_location!
  end

  # Place the fighter in the world.
  def spawn
    connection.puts "\nSpawning in the world!\n"

    @world = World.instance
    @world.join(self)

    process_input
  end

  # Character to represent this fighter.
  def icon
    name[0]
  end

  # Is the fighter at the given coordinates?
  def located_here?(x,y)
    self.location == [x,y]
  end

  private
    ###
    # User interaction
    ###
    def ask_name
      connection.puts "What's your name?"
      connection.gets.chomp
    end

    def process_input
      while movement = connection.gets.chomp
        begin
          parse(movement)

        # Keep parsing text until we're told to quit.
        rescue QuitException
          break
        end
      end
    end

    def parse(movement)
      case movement

      when up?
        move(:up)

      when left?
        move(:left)

      when down?
        move(:down)

      when right?
        move(:right)

      when quit?
        confirm_quit

      else
        invalid_direction
      end
    end

    ###
    # Movement text
    ###
    def up?
      /[w|W]/
    end

    def left?
      /[a|A]/
    end

    def down?
      /[s|S]/
    end

    def right?
      /[d|D]/
    end

    def quit?
      /[q|Q]/
    end

    ###
    # Movement
    ###
    def move(direction)
      send(direction)

      @world.fighter_moved
    end

    def up
      self.x = (((x-1)+10)%10)
    end

    def left
      self.y = (((y-1)+10)%10)
    end

    def down
      self.x = ((x+1)%10)
    end

    def right
      self.y = ((y+1)%10)
    end

    def invalid_direction
      connection.puts "Invalid movement. Please use WASD to move!"

      sleep(0.5)

      @world.render
    end

    ###
    # Coordinates
    ###
    def x
      location[0]
    end

    def x=(point)
      location[0] = point
    end

    def y
      location[1]
    end

    def y=(point)
      location[1] = point
    end

    ###
    # Quitting
    ###
    class QuitException < SystemExit
    end

    def confirm_quit
      connection.puts "Are you sure you want to quit?"
      if yes_entered?
        raise QuitException

      else
        @world.render
      end
    end

    # Did the text the fighter entered start with a y?
    def yes_entered?
      /y|Y/.match(connection.gets.chomp)
    end
end

