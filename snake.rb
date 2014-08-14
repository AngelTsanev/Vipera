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

  def eat_food
    @food_eaten = true
  end

  def done_eating_food
    @food_eaten = false
  end

  def move_up
    head_x, head_y = get_head
    @body.insert(0, [head_x, head_y-1])
    if food_eaten?
      done_eating_food
    else
      @body.delete_at(-1)
    end
  end

  def move_down
    head_x, head_y = get_head
    @body.insert(0, [head_x, head_y-1])
    if food_eaten?
      done_eating_food
    else
      @body.delete_at(-1)
    end
  end

  def move_left
    head_x, head_y = get_head
    @body.insert(0, [head_x-1, head_y])
    if food_eaten?
      done_eating_food
    else
      @body.delete_at(-1)
    end
  end

  def move_right
    head_x, head_y = get_head
    @body.insert(0, [head_x+1, head_y])
    if food_eaten?
      done_eating_food
    else
      @body.delete_at(-1)
    end
  end 

end





