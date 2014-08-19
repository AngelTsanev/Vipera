class Frame
  attr_reader :pixels, :width, :height

  def initialize(map, snake, food)
    @pixels = {}
    @width = map.width
    @height = map.height
    draw_map(map)
    draw_snake(snake)
    draw_food(food)
  end

  def draw_map(map)
    @pixels.merge!(map.pixels)
  end

  def draw_snake(snake)
    0.upto(snake.pixels.length.pred) do |i|
      @pixels[snake.pixels[i]] = 1
    end
  end

  def draw_food(food)
    @pixels[[food.x, food.y]] = 2
  end

  def pixel_at?(x, y)
    @pixels[[x, y]] == 0 or @pixels[[x, y]] == 1 or @pixels[[x, y]] == 2
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
    if @frame.pixels[[x, y]] == 2
      return '@'
    end
    if @frame.pixels[[x, y]] == 1 
      return '+'
    end
    if @frame.pixels[[x, y]] == 0 
      return '#'
    end
  end

  def blank_pixel
    '-'
  end

  def join_pixels_in(line)
    line.join('')
  end

  def join_lines(lines)
    lines.join("\n")
  end
end