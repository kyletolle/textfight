require 'socket'

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

    fighters << f
    broadcast("New fighter connected!", fighters)

    f.puts "What's your name?"
    while f.gets
      # Do something
    end

    fighters.delete f
    f.close
  end
end

