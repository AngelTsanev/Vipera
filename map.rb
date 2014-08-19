class Map
  attr_reader :width, :height, :pixels
  
  def initialize(mapname)
    @pixels = {}
    read_map(mapname)
  end

  def read_map(mapname)
    file = IO.readlines("./Maps/" + mapname + ".vmp")
    @width = file[0].tr("'\n", "").length
    @height = file.size
    0.upto(file.size.pred) do |y|
    #puts "#{file[x].tr("'\n", "").length} -> #{file[x]}"
      0.upto(file[y].size-2) do |x|
        set_pixel(x, y) if file[y][x].eql?(1)
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