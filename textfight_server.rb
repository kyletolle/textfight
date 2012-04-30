require 'socket'

def welcome(fighter)
  fighter.print "Welcome! Please enter your name: "
  fighter.readline.chomp
end

def broadcast(text, fighters)
  fighters.each do |fighter|
    fighter.puts text
  end
end


s = TCPServer.new(3939)
fighters = []

while (fighter = s.accept)
  Thread.new(fighter) do |f|
    if fighters.size >= 2
      f.puts "There are already 2 fighters!"
      f.close
    end

    name = welcome(fighter)
    broadcast("#{name} has joined", fighters)
    fighters << f

    begin
      loop do
        line = f.readline
        broadcast("#{name}: #{line}", fighters)
      end
    rescue EOFError
      f.close
      fighters.delete f 
      broadcast("#{name} has left", fighters)
    end
  end
end

