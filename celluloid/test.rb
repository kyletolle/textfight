require "celluloid/current"

class World
  include Celluloid

  def initialize
    @fighters ||= []
  end

  def add(fighter)
    @fighters << fighter
  end

  def map
    @fighters.each do |f|
      puts f
    end
    puts
  end

  def size
    @fighters.size
  end
end

@world = World.new
Thread.new do |t|
  sleep 0.5+rand
  @world.async.add "Kyle"
end

Thread.new do |t|
  sleep 0.5+rand
  @world.async.add "Chris"
end

loop do
  sleep 0.05
  @world.map
  exit if @world.size >= 2
end
