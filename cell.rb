class Cell
  def initialize
    @fighters = []
  end

  def holds?(fighter)
    @fighters.include?(fighter)
  end

  def hold(fighter)
    @fighters << fighter
  end

  def remove(fighter)
    @fighters.delete(fighter)
  end

  def to_s
    text = ""
    if @fighters.size > 0
      text += @fighters[0].name[0]
    else
      text += " "
    end
    text
  end
end
