require 'socket'

def broadcast(text, fighters)
  @fighters.each do |fighter|
    fighter.connection.puts text
  end
end

class Fighter
  attr_accessor :connection, :name

  def initialize(c)
    self.connection = c
  end
end

class World
  def initialize
    @accepted ||= []
  end

  def join(fighter)
    start_fight_text = "\nDo you want to start the fight? Waiting for a yes: "
    fighter.connection.puts start_fight_text
    while !/y|Y/.match (fighter.connection.gets.chomp)
      fighter.connection.puts "Please enter 'yes' when you're ready."
      fighter.connection.puts start_fight_text
    end

    @accepted << fighter

    if @accepted.size < 2
      fighter.connection.puts "\nWaiting for the other fighter to start the fight."
      while @accepted.size < 2
        sleep 0.5
      end
    end

    fighter.connection.puts ("\nStarting the fight!")
  end

  def map
    "[ ][ ][ ][ ][ ][ ][ ][ ][ ][ ]\n" +
    "[ ][ ][ ][ ][ ][ ][ ][ ][ ][ ]\n" +
    "[ ][ ][ ][ ][ ][ ][ ][ ][ ][ ]\n" +
    "[ ][ ][ ][ ][ ][ ][ ][ ][ ][ ]\n" +
    "[ ][ ][ ][ ][ ][ ][ ][ ][ ][ ]\n" +
    "[ ][ ][ ][ ][ ][ ][ ][ ][ ][ ]\n" +
    "[ ][ ][ ][ ][ ][ ][ ][ ][ ][ ]\n" +
    "[ ][ ][ ][ ][ ][ ][ ][ ][ ][ ]\n" +
    "[ ][ ][ ][ ][ ][ ][ ][ ][ ][ ]\n" +
    "[ ][ ][ ][ ][ ][ ][ ][ ][ ][ ]\n"
  end


  def step(fighter, input)
    case input
    when "w"
      fighter.connection.puts "WWWWWW!"
    when "a"
      fighter.connection.puts "AAAAAA!"
    when "s"
      fighter.connection.puts "SSSSSS!"
    when "d"
      fighter.connection.puts "DDDDDD!"
    else
      fighter.connection.puts "OTHER!!!!!!"
    end
  end
end

def connection_limit_reached?
  return @fighters.size >= 2
end

def connection_limit_check(c)
  if connection_limit_reached?
    c.puts "There are already 2 fighters!"
    c.close
  end
end

server = TCPServer.new(3939)
@fighters = []

@world = World.new

puts "Server started. Waiting for connections..."

while (connection = server.accept)
  Thread.new(connection) do |c|
    c.puts
    c.puts "Welcome to textfight!"

    connection_limit_check(c)

    fighter = Fighter.new(c)

    @fighters << fighter

    fighter.connection.puts "What's your name?"
    fighter.name = fighter.connection.gets.chomp

    broadcast("\nNew fighter connected!", @fighters)
    broadcast("All fighters joined so far:", @fighters)
    @fighters.each do |f|
      broadcast("  #{f.name}", @fighters)
    end

    # This actually makes sure both fighters joined before it returns.
    @world.join(fighter)

    fighter.connection.puts @world.map

    while text = fighter.connection.gets.chomp
      @world.step(fighter, text)
    end

    @fighters.delete fighter
    fighter.connection.close
  end
end

