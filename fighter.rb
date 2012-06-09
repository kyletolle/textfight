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

  def icon
    name[0]
  end

  def located_here?(x,y)
    self.location == [x,y]
  end

  private
    def ask_name
      connection.puts "What's your name?"
      connection.gets.chomp
    end

    def process_input
      while text = connection.gets.chomp
        begin
          parse(text)

        # Keep parsing text until we're told to quit.
        rescue QuitException
          break
        end
      end
    end

    def parse(text)
      case text

      when /[w|W]/
        move(:up)

      when /[a|A]/
        move(:left)

      when /[s|S]/
        move(:down)

      when /[d|D]/
        move(:right)

      when "q"
        confirm_quit

      else
        invalid_direction
      end
    end

    def move(direction)
      send(direction)

      @world.fighter_moved
    end

    def up
      location[0] = (((location[0]-1)+10)%10)
    end

    def left
      location[1] = (((location[1]-1)+10)%10)
    end

    def down
      location[0] = ((location[0]+1)%10)
    end

    def right
      location[1] = ((location[1]+1)%10)
    end

    def invalid_direction
      connection.puts "Invalid movement. Please use WASD to move!"

      sleep(0.5)

      @world.render
    end

    class QuitException < SystemExit
    end

    def confirm_quit
      connection.puts "Are you sure you want to quit?"
      if yes_entered?
        raise QuitException
      end
    end

    # Did the text the fighter entered start with a y?
    def yes_entered?
      /y|Y/.match(connection.gets.chomp)
    end
end

