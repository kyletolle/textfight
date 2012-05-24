class World
  def initialize
    @accepted ||= []
  end

  def join(fighter)
    start_fight_text = "\nDo you want to start the fight? Waiting for a yes: "
    fighter.connection.puts start_fight_text
    while !/y|Y/.match (fighter.connection.gets.chomp)
      fighter.connection.puts "Please enter 'yes' when you're ready."
      fighter.connection.puts start_fight_text
    end

    @accepted << fighter

    if @accepted.size < 2
      fighter.connection.puts "\nWaiting for the other fighter to start the fight."
      while @accepted.size < 2
        sleep 0.5
      end
    end

    fighter.connection.puts ("\nStarting the fight!")
  end

  def map
    "[ ][ ][ ][ ][ ][ ][ ][ ][ ][ ]\n" +
    "[ ][ ][ ][ ][ ][ ][ ][ ][ ][ ]\n" +
    "[ ][ ][ ][ ][ ][ ][ ][ ][ ][ ]\n" +
    "[ ][ ][ ][ ][ ][ ][ ][ ][ ][ ]\n" +
    "[ ][ ][ ][ ][ ][ ][ ][ ][ ][ ]\n" +
    "[ ][ ][ ][ ][ ][ ][ ][ ][ ][ ]\n" +
    "[ ][ ][ ][ ][ ][ ][ ][ ][ ][ ]\n" +
    "[ ][ ][ ][ ][ ][ ][ ][ ][ ][ ]\n" +
    "[ ][ ][ ][ ][ ][ ][ ][ ][ ][ ]\n" +
    "[ ][ ][ ][ ][ ][ ][ ][ ][ ][ ]\n"
  end


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

