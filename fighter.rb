require './world'

class Fighter
  attr_accessor :connection, :name

  def initialize(connection)
    self.connection = connection
  end

  def battle
      # This actually makes sure both fighters joined before it returns.
      world = World.instance
      world.join(self)

      connection.puts world.map

      while text = connection.gets.chomp
        process_input(text)
      end
  end

  private
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
      else
        connection.puts "OTHER!!!!!!"
      end
    end
end

