class Frame
  attr_reader :pixels, :width, :height

  def initialize(map, food, snake_one, snake_two=nil)
    @pixels = {}
    @width = map.width
    @height = map.height
    draw_map(map)
    draw_snake(snake_one, 1)
    if snake_two != nil
      draw_snake(snake_two, 3)
    end

    draw_food(food)
  end

  def draw_map(map)
    @pixels.merge!(map.pixels)
  end

  def draw_snake(snake, number)
    0.upto(snake.pixels.length.pred) do |i|
      @pixels[snake.pixels[i]] = number
    end
  end

  def draw_food(food)
    @pixels[[food.x, food.y]] = 2
  end

  def pixel_at?(x, y)
    @pixels.has_key?([x, y])
  end
end


class Ascii_render
  attr_reader :frame

  def initialize(frame)
    @frame = frame
  end

  def render
    pixels = 0.upto(frame.height.pred).map do |y|
      0.upto(frame.width.pred).map { |x| pixel_at(x, y) }
    end

    join_lines pixels.map { |line| join_pixels_in line }
  end

  private

  def pixel_at(x, y)
    @frame.pixel_at?(x, y) ? fill_pixel(x, y) : blank_pixel
  end

  def fill_pixel(x, y)
    case @frame.pixels[[x, y]]
      when 3
        return char_snake2
      when 2
        return char_food
      when 1
        return char_snake1
      when 0
        return char_wall
    end
  end

  def blank_pixel
    '-'
  end

  def char_snake2
    'o'
  end

  def char_snake1
    '+'
  end

  def char_food
    '@'
  end

  def char_wall
    '#'
  end

  def join_pixels_in(line)
    line.join('')
  end

  def join_lines(lines)
    lines.join("\n")
  end
end