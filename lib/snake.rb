class Snake
  attr_accessor :pixels, :direction, :score, :alive, :char
  attr_reader :width, :height

  def initialize(width, height, direction=:right, score=0, pixels=[])
    @direction = direction
    @score  = score
    @pixels = pixels
    @alive = true
    @width = width
    @height = height

    if pixels.empty?
      if direction == :right
        x, y = (width/2).round, (height/2).round
        @pixels.insert(-1, [x+7, y])
        @pixels.insert(-1, [x+6, y])
        @pixels.insert(-1, [x+5, y])
      else
        x, y = (width/2).round, (height/2).round
        @pixels.insert(-1, [x-7, y])
        @pixels.insert(-1, [x-6, y])
        @pixels.insert(-1, [x-5, y])
      end
    end
  end

  def get_head
    return @pixels.first.dup
  end

  def pixel_at?(x, y)
    @pixels.include?([x, y])
  end

  def serialize
    [@width, @height, @direction, @score, @pixels]
  end

  def kill
    @alive = false
  end
end