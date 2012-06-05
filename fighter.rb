require './world'

class Fighter
  attr_accessor :connection, :name

  def initialize(connection)
    self.connection = connection
    self.name = ask_name
  end

  def battle
    connection.puts "\nStarting the fight!\n"

    # This actually makes sure both fighters joined before it returns.
    @world = World.instance
    @world.join(self)

    connection.puts @world.map

    process_input
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
        rescue QuitException
          break
        end
      end
    end

    def parse(text)
      case text
      when "w"
        connection.puts "WWWWWW!"
      when "a"
        connection.puts "AAAAAA!"
      when "s"
        connection.puts "SSSSSS!"
      when "d"
        connection.puts "DDDDDD!"
      when "q"
        confirm_quit
      else
        connection.puts "OTHER!!!!!!"
      end

      connection.puts
      connection.puts @world.map
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

