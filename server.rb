require './fighter'
require './world'

class Server
  def initialize
    @server = TCPServer.new(3939)
    @fighters = []
    @world = World.new

    puts "Server started. Waiting for connections..."
  end


  def start
    accept_connections
  end

  private
    def accept_connections
      while (connection = @server.accept)
        Thread.new(connection) do |c|
          new_connection(c)
        end
      end

    end

    def new_connection(connection)
      connection_limit_check(connection)

      fighter = create_new_fighter(connection)

      welcome(fighter)

      fighter.name = ask_name(fighter)

      announce_fighter_join

      # This actually makes sure both fighters joined before it returns.
      @world.join(fighter)

      fighter.connection.puts @world.map

      while text = fighter.connection.gets.chomp
        @world.step(fighter, text)
      end

      disconnect(fighter)
    end

    def create_new_fighter(connection)
      fighter = Fighter.new(connection)

      @fighters << fighter

      fighter
    end

    def welcome(fighter)
      fighter.connection.puts
      fighter.connection.puts "Welcome to textfight!"
    end

    def ask_name(fighter)
      fighter.connection.puts "What's your name?"
      fighter.connection.gets.chomp
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

