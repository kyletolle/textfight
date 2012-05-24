require 'socket'

def broadcast(text, fighters)
  @fighters.each do |fighter|
    fighter.connection.puts text
  end
end

class Fighter
  attr_accessor :connection, :name
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
    nil
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
    if @fighters.size >= 2
      c.puts "There are already 2 fighters!"
      c.close
    end

    fighter = Fighter.new
    fighter.connection = c

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

    broadcast("Need to print world state right here!", @fighters)
    while text = fighter.connection.gets.chomp
      @world.step(fighter, text)
    end

    @fighters.delete fighter
    fighter.connection.close
  end
end

