class Snake:
  attr_accessor :body, :food_eaten
  attr_reader :width, :height

  def initialize(width, height)
    @food_eaten = false
    @width  = width
    @height = height    
    x, y = (width/2).round, (height/2).round
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

  def move_same_direction
    head_x, head_y = get_head
    neck_x, neck_y = @body[1]
    if head_x.eql?(neck_x)
      if head_y > neck_y
        move_up
      else
        move_down
      end
    else
      if head_x > neck_x 
        move_right
      else
        move_left
      end
    end
  end
end





