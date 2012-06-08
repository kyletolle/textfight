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

      wait_for_both_fighters

      fighter.battle

      disconnect(fighter)

      announce_fighter_leave
    end

    def wait_for_both_fighters
      # If we're still waiting on the other fighter
      if !both_fighters_connected?
        broadcast("\nWaiting for the other fighter to start the fight.")
        while !both_fighters_connected?
          sleep 0.5
        end
      end
    end

    def both_fighters_connected?
      @fighters.size == 2
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

    def fighters_connected
      broadcast("All fighters connected:")
      @fighters.each do |f|
        broadcast("  #{f.name}")
      end
    end

    def announce_fighter_join
      broadcast("\nNew fighter connected!")
      fighters_connected
    end

    def broadcast(text)
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

    def announce_fighter_leave
      broadcast("\nFighter disconnected!")
      fighters_connected
    end

    def disconnect(fighter)
      @fighters.delete fighter
      fighter.connection.close
    end
end

