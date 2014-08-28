class Map
  attr_reader :width, :height, :pixels
  
  def initialize(map_name)
    @pixels = {}
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
    @pixels[[x, y]] == 0
  end
end