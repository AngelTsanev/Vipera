class Food
  attr_reader :x, :y

  def initialize
    @x = 0
    @y = 0
  end

  def set_food(x, y)
    @x, @y = x, y
  end

  def food_at?(x, y)
    x.eql?(@x) and y.eql?(@y)
  end

  def serialize
    [@x, @y]
  end
end