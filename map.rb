class Map
  attr_reader :width, :height, :pixels, :map_name

  def initialize(map_name)
    @pixels = {}
    @map_name = map_name
    read_map(map_name)
  end

  def read_map(map_name)
    file = IO.readlines("./Maps/" + map_name + ".vmp")
    @width = file[0].tr("'\n", "").length
    @height = file.size
    0.upto(file.size.pred) do |y|
      0.upto(file[y].size) do |x|
        set_pixel(x, y) if file[y][x].eql?('1')
      end
    end
  end

  def set_pixel(x, y)
    @pixels[[x, y]] = 0
  end

  def pixel_at?(x, y)
    @pixels.has_key?([x, y])
  end

  def serialize
    [@map_name]
  end
end