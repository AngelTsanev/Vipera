class Snake:
  attr_accessor :body, :food_eaten

  def initialize(start_x, start_y)
    @food_eaten = false
    x, y = start_x, start_y
    @body.insert(-1, [x, y])
    @body.insert(-1, [x-1, y])
    @body.insert(-1, [x-2, y])
    @body.insert(-1, [x-3, y])
  end

  def get_head
    return @body.first.dup
  end

  def food_eaten?
    return @food_eaten
  end

  def move_up
    head_x, head_y = get_head
    @body.insert(0, [head_x, head_y-1])
    @body.delete_at(-1) unless food_eaten?
  end

  def move_down
  end

  def move_left
  end

  def move_right
  end 
end





