require './cell'

class World
  
  def self.instance
    @instance ||= World.new
    @instance
  end

  # Asks the user whether they're ready to start the battle
  def join(fighter)
    start_fight_text = "\nDo you want to start the fight? Waiting for a yes: "
    fighter.connection.puts start_fight_text

    # While the user inputs anything not starting with a "y", prompt for "yes".
    while !/y|Y/.match(fighter.connection.gets.chomp)
      fighter.connection.puts "Please enter 'yes' when you're ready."
      fighter.connection.puts start_fight_text
    end

    # They entered yes, so they are an accepted user.
    @accepted << fighter

    # If we're still waiting on the other use
    if !both_users_accepted?
      fighter.connection.puts "\nWaiting for the other fighter to start the fight."
      while !both_users_accepted?
        sleep 0.5
      end
    end

    fighter.connection.puts("\nStarting the fight!")
  end

  # Returns string of the state of the world.
  def map

    state_text = ""

    @grid.each.with_index do |row, index|
      row.each.with_index do |cell, index|
        state_text += " #{cell} "
        state_text += "|" if index < 9
      end
      state_text << "\n---------------------------------------\n" if index < 9
    end

    state_text
  end

  private

    World_Dimension = 10

    def initialize
      @accepted ||= []
      create_world
    end

    def create_world
      create_grid
    end

    def create_grid
      @grid = []
      10.times do
        row = []
        10.times { row << Cell.new }
        @grid << row
      end
    end

    # Did the text the fighter entered start with a y?
    def yes_entered?
      /y|Y/.match(fighter.connection.gets.chomp)
    end

    # Have two users joined the world?
    def both_users_accepted?
      @accepted.size == 2
    end
end

