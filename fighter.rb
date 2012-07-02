require './world'

# Represents the fighters that interact with the server.
class Fighter
  # Publicly accessible methods.
  attr_accessor :connection, :name, :location, :number

  # Create the fighter
  def initialize(connection)
    self.connection = connection
    self.name = ask_name

    @world = World.instance
    self.number = @world.join(self)
    self.location = @world.starting_location!
  end

  # Place the fighter in the world.
  def spawn
    connection.puts "\nSpawning in the world!\n"

    @world.render

    process_input

  # Fighter disconnecting raises an exception, which we can catch.
  # Since one of the fighters is gone, we want to reset the world.
  rescue
    World.reset
    raise
  end

  # Character to represent this fighter.
  def icon
    self.number
  end

  # Is the fighter at the given coordinates?
  def located_here?(x,y)
    self.location == [x,y]
  end

  private
    ###
    # User interaction
    ###
    # Get the fighter's name.
    def ask_name
      begin
        connection.puts "What's your name? (10 alphanum/spaces only, please.)"
        # Only grab 10 characters.
        name = connection.gets.chomp[0..10]
      end while !only_chars?(name)
      name
    end

    # Check these are only word characters and spaces.
    def only_chars?(text)
      text.match(/^\w[\w| ]+$/i)
    end

    # Handle the input from the fighter.
    def process_input

      while movement = connection.gets.chomp
        begin
          parse(movement)
        end
      end
    end

    # Parse a string into a movement.
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

    # Move the fighter up in the world, wrapping around the edges.
    def up
      self.x = (((x-1)+10)%10)
    end

    # Move the fighter left in the world, wrapping around the edges.
    def left
      self.y = (((y-1)+10)%10)
    end

    # Move the fighter down in the world, wrapping around the edges.
    def down
      self.x = ((x+1)%10)
    end

    # Move the fighter right in the world, wrapping around the edges.
    def right
      self.y = ((y+1)%10)
    end

    # Fighter gave an invalid movement; let them know.
    def invalid_direction
      connection.puts "Invalid movement. Please use WASD to move!"

      # Show the text for a short time before showing the world again.
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
    # Make sure the user wants to quit.
    def confirm_quit
      connection.puts "Are you sure you want to quit?"
      if yes_entered?
        connection.close

      else
        @world.render
      end
    end

    # Does the fighter enter text starting with a 'y'?
    def yes_entered?
      /y|Y/.match(connection.gets.chomp)
    end
end

