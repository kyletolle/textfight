require './world'

class Fighter
  attr_accessor :connection, :name

  def initialize(connection)
    self.connection = connection
    self.name = ask_name
  end

  def battle
      # This actually makes sure both fighters joined before it returns.
      world = World.instance
      world.join(self)

      connection.puts world.map

      while text = connection.gets.chomp
        begin
          process_input(text)
        rescue QuitException
          break
        end
      end
  end

  private
    def ask_name
      connection.puts "What's your name?"
      connection.gets.chomp
    end

    def process_input(input)
      case input
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
    end

    class QuitException < SystemExit
    end

    def confirm_quit
      connection.puts "Are you sure you want to quit?"
      if yes_entered?
        raise QuitException
      end
    end

    def yes_entered?
      /y|Y/.match (connection.gets.chomp)
    end
end

