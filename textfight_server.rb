require 'socket'

def broadcast(text, fighters)
  fighters.each do |fighter|
    fighter.connection.puts text
  end
end

class Fighter
  attr_accessor :connection
end


server = TCPServer.new(3939)
fighters = []

puts "Server started. Waiting for connections..."

while (connection = server.accept)
  Thread.new(connection) do |c|
    c.puts
    c.puts "Welcome to textfight!"
    if fighters.size >= 2
      c.puts "There are already 2 fighters!"
      c.close
    end

    fighter = Fighter.new
    fighter.connection = c

    fighters << fighter
    broadcast("New fighter connected!", fighters)

    fighter.connection.puts "What's your name?"
    while text = fighter.connection.gets
      broadcast(text, fighters)
    end

    fighters.delete fighter
    fighter.connection.close
  end
end

