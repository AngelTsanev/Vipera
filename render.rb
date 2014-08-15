class Frame
  attr_reader :pixels, :width, :height

  def initialize(map)
    @width  = width
    @height = height
    @pixels = set_map(map)
  end

  def set_map(map)
  end

  def set_snake(snake)
  end
end


class Ascii_render
  attr_reader :frame

  def initialize(frame)
    @frame = frame
  end
  
end