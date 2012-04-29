require 'socket'

s = TCPServer.new(3939)

while (fighter = s.accept)
  Thread.new(fighter) do |f|
    f.puts "Hello, fighter!"
    f.close
  end
end

