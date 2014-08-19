class Food
  attr_reader :x, :y, :map 

  def initialize(map)
    @map = map
    set_food
  end

  def set_food
    x = rand(map.width)
    y = rand(map.height)
    while @map.pixel_at?(x, y) and @snake.pixel_at?(x, y)
      x = rand(map.width)
      y = rand(map.height)
    end
    @x, @y = x, y
  end
end