module Food_and_Snake
    def make_food
    food_coordinates = get_free_pixel
    @food.set_food(food_coordinates[0], food_coordinates[1])
  end

  def food_at?(x, y)
    return @food.food_at?(x, y)
  end

  def eat_food(snake)
    snake.score += 1
    make_food
  end

  def get_free_pixel
    x = rand(@width)
    y = rand(@height)

    while pixel_at?(x, y)
      x = rand(@width)
      y = rand(@height)
    end
    [x, y]
  end

  def pixel_at?(x, y)
    if @multiplayer
      @snake_one.pixel_at?(x, y) or @snake_two.pixel_at?(x, y) or
      @map.pixel_at?(x, y)
    else
      @snake_one.pixel_at?(x, y) or @map.pixel_at?(x, y)
    end
  end

  def make_snake_crawl(snake)
    case snake.direction
      when :up    then move_up(snake)
      when :down  then move_down(snake)
      when :left  then move_left(snake)
      when :right then move_right(snake)
    end
  end

  def move_up(snake)
    head_x, head_y = snake.get_head
    snake.pixels.insert(0, [head_x, (head_y-1) % @height])
    if food_at?(head_x, head_y-1)
      eat_food(snake)
    else
      snake.pixels.delete_at(-1)
    end
  end

  def move_down(snake)
    head_x, head_y = snake.get_head
    snake.pixels.insert(0, [head_x, (head_y+1) % @height])
    if food_at?(head_x, head_y+1)
      eat_food(snake)
    else
      snake.pixels.delete_at(-1)
    end
  end

  def move_left(snake)
    head_x, head_y = snake.get_head
    snake.pixels.insert(0, [(head_x-1) % @width, head_y])
    if food_at?(head_x-1, head_y)
      eat_food(snake)
    else
      snake.pixels.delete_at(-1)
    end
  end

  def move_right(snake)
    head_x, head_y = snake.get_head
    snake.pixels.insert(0, [(head_x+1) % @width, head_y])
    if food_at?(head_x+1, head_y)
      eat_food(snake)
    else
      snake.pixels.delete_at(-1)
    end
  end

  def hits_self?(snake)
    snake_head = snake.get_head
    1.upto(snake.pixels.size.pred) do |i|
      if snake.pixels[i] == snake_head
        return true
      end
    end
    return false
  end

  def collision?
    collision = false
    head_x, head_y = @snake_one.get_head
    if @map.pixel_at?(head_x, head_y) or hits_self?(@snake_one)
      @snake_one.kill
      collision = true
    end

    if @multiplayer
      head_x, head_y = @snake_two.get_head
      if @map.pixel_at?(head_x, head_y) or hits_self?(@snake_two)
        @snake_two.kill
        collision = true
      end

      if @snake_one.pixel_at?(head_x, head_y)
        @snake_two.kill
        collision = true
      end

      head_x, head_y = @snake_one.get_head
      if @snake_two.pixel_at?(head_x, head_y)
        @snake_one.kill
        collision = true
      end
    end
    return collision
  end
end