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
        accept(connection)
      end
    end

    def accept(connection)
      Thread.new(connection) do |c|
        # Rescues errors with connection.
        begin
          # Don't want too many people to connect.
          connection_limit_check(c)

          # Set up the fighter.
          fighter = join_fighter(c)

          # Need all fighters to join before starting the game.
          wait_for_both_fighters

          # Start the game!
          fighter.spawn

          # Game is finished, so disconnect.
          disconnect(fighter)

        # Fighter disconnecting raises an exception.
        # We need to reset our state so we can accept more connections.
        rescue
          reset
        end
      end
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

    def join_fighter(connection)
      welcome(connection)

      fighter = new_fighter(connection)

      announce_fighter_join

      fighter
    end

    def new_fighter(connection)
      fighter = Fighter.new(connection, @fighters.size)

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

      announce_fighter_leave
    end

    # 
    def reset
      @fighters.each do |fighter|
        begin
          fighter.connection.puts("Other fighter left. Disconnecting.")
          fighter.connection.close

        # One of the fighters is dead, so this keeps server from blowing up.
        rescue
          nil

        ensure
          # We really need to remove the fighter.
          @fighters.delete(fighter)
        end
      end
    end
end

