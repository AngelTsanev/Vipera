class Snake
  attr_accessor :pixels, :direction, :paused
  attr_reader :width, :height, :map, :food, :score

  def initialize(map, food)
    @direction = :right
    @score  = 0
    @paused = false
    @pixels = []
    @map = map
    @food = food

    x, y = (map.width/2).round, (map.height/2).round
    @pixels.insert(-1, [x, y])
    @pixels.insert(-1, [x-1, y])
    @pixels.insert(-1, [x-2, y])
    @pixels.insert(-1, [x-3, y])
    make_food
  end

  def get_head
    return @pixels.first.dup
  end

  def food_at?(x, y)
    return @food.food_at?(x, y)
  end

  def get_free_pixel
    x = rand(@map.width)
    y = rand(@map.height)

    while pixel_at?(x, y)
      x = rand(@map.width)
      y = rand(@map.height)
    end
    [x, y]
  end
  
  def eat_food
    @score += 1
    make_food
  end

  def make_food
    food_coordinates = get_free_pixel
    @food.set_food(food_coordinates[0], food_coordinates[1])
  end

  def pixel_at?(x, y)
    @pixels.include?([x, y]) or @map.pixel_at?(x, y) 
  end

  def move_up
    head_x, head_y = get_head
    @pixels.insert(0, [head_x, (head_y-1) % map.height])
    if food_at?(head_x, head_y-1)
      eat_food
    else
      @pixels.delete_at(-1)
    end
  end

  def move_down
    head_x, head_y = get_head
    @pixels.insert(0, [head_x, (head_y+1) % map.height])
    if food_at?(head_x, head_y+1)
      eat_food
    else
      @pixels.delete_at(-1)
    end
  end

  def move_left
    head_x, head_y = get_head
    @pixels.insert(0, [(head_x-1) % map.width, head_y])
    if food_at?(head_x-1, head_y)
      eat_food
    else
      @pixels.delete_at(-1)
    end
  end

  def move_right
    head_x, head_y = get_head
    @pixels.insert(0, [(head_x+1) % map.width, head_y])
    if food_at?(head_x+1, head_y)
      eat_food
    else
      @pixels.delete_at(-1)
    end
  end 

  def move!
    case @direction
      when :up    then move_up
      when :down  then move_down
      when :left  then move_left
      when :right then move_right
    end
  end

  def collision?
    head_x, head_y = get_head
    kill_snake if @map.pixel_at?(head_x, head_y)
  end

  def kill_snake
    system("clear")
    puts "Your score is: " + @score.to_s + "!"
    sleep(5)
    exit
  end
end