require './fighter'

class Server
  def initialize
    @server = TCPServer.new(3939)
    @fighters = []
  end

  def start
    accept_connections
  end

  private
    def accept_connections
      puts "Server started. Accepting connections..."

      while (connection = @server.accept)
        Thread.new(connection) do |c|
          new_connection(c)
        end
      end

    end

    def new_connection(connection)
      connection_limit_check(connection)

      welcome(connection)

      fighter = new_fighter(connection)

      announce_fighter_join

      fighter.battle

      disconnect(fighter)
    end

    def new_fighter(connection)
      fighter = Fighter.new(connection)

      @fighters << fighter

      fighter
    end

    def welcome(connection)
      connection.puts
      connection.puts "Welcome to textfight!"
    end

    def announce_fighter_join
      broadcast("\nNew fighter connected!", @fighters)
      broadcast("All fighters joined so far:", @fighters)
      @fighters.each do |f|
        broadcast("  #{f.name}", @fighters)
      end
    end

    def broadcast(text, fighters)
      @fighters.each do |fighter|
        fighter.connection.puts text
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

    def disconnect(fighter)
      @fighters.delete fighter
      fighter.connection.close
    end
end

