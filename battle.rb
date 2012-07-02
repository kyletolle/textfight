class Battle
  def initialize(fighters)
    @fighters = fighters

    broadcast blank_lines
    broadcast "Two fighters have stumbled upon the same area."
    broadcast "And so the fight begins..."
    broadcast

    begin
      2.times do |number|
        turn(number-1) if fighters_both_alive?
      end
      broadcast
    end while fighters_both_alive?

    broadcast "The fight is over! The winner is..." 
    broadcast @winner.name

    broadcast 
    broadcast "This textfight has ended. Thanks for fighting!"
    broadcast "Start the client once more to play again."
  end

  private

    def broadcast(text="")
      @fighters.each do |fighter|
        fighter.connection.puts text
      end
    end

    # TODO: remove duplication with world.rb
    # Returns multiple newlines.
    def blank_lines
      blank_lines = ""
      15.times { blank_lines += "\n" }
      blank_lines
    end

    def fighters_both_alive?
      fighters_alive = 0
      @fighters.each do |fighter|
        fighters_alive += 1 if fighter.alive?
      end
      fighters_alive == 2
    end

    def turn(x)
      attacker = @fighters[x]
      defender = @fighters[(x+1)%2]

      damage = rand 20
      defender.health -= damage

      broadcast "#{attacker.name} did #{damage} damage to #{defender.name}"

      if defender.alive?
        broadcast "#{defender.name} now has #{defender.health} health"
      else
        broadcast "#{defender.name} died from wounds"
        @winner = attacker if !defender.alive?
      end
    end
end

