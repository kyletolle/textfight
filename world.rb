class World
  def initialize
    @accepted ||= []
  end

  # 
  def join(fighter)
    start_fight_text = "\nDo you want to start the fight? Waiting for a yes: "
    fighter.connection.puts start_fight_text

    # While the user inputs anything not starting with a "y", prompt for "yes".
    while !/y|Y/.match (fighter.connection.gets.chomp)
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

    fighter.connection.puts ("\nStarting the fight!")
  end

  # Did the text the fighter entered start with a y?
  def yes_entered?
    /y|Y/.match (fighter.connection.gets.chomp)
  end

  # Have two users joined the world?
  def both_users_accepted?
    @accepted.size == 2
  end

  # Returns string of the state of the world.
  def map
    "   |   |   |   |   |   |   |   |   |   \n" +
    "---------------------------------------\n" +
    "   |   |   |   |   |   |   |   |   |   \n" +
    "---------------------------------------\n" +
    "   |   |   |   |   |   |   |   |   |   \n" +
    "---------------------------------------\n" +
    "   |   |   |   |   |   |   |   |   |   \n" +
    "---------------------------------------\n" +
    "   |   |   |   |   |   |   |   |   |   \n" +
    "---------------------------------------\n" +
    "   |   |   |   |   |   |   |   |   |   \n" +
    "---------------------------------------\n" +
    "   |   |   |   |   |   |   |   |   |   \n" +
    "---------------------------------------\n" +
    "   |   |   |   |   |   |   |   |   |   \n" +
    "---------------------------------------\n" +
    "   |   |   |   |   |   |   |   |   |   \n" +
    "---------------------------------------\n" +
    "   |   |   |   |   |   |   |   |   |   \n"
  end

  # Process the user's step, which is indicated by the key they typed.
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
  end
end

