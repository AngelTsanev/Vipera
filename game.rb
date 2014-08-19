require './snake'
require './render'

map = Map.new('trivial')
food = Food.new(map)
snake = Snake.new(map.width, map.height)

frame = Frame.new(map, snake, food)


puts map.pixels

render = Ascii_render.new(frame)

puts render.render