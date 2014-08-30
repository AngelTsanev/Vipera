require 'test/unit'
require './game'


class TestSnake < Test::Unit::TestCase
  def test_get_head
    snake = Snake.new(100, 200)
    expected = snake.pixels.first
    assert_equal expected, snake.get_head
  end

  def test_pixels_of_snake_first_directed_right
    snake = Snake.new(100, 200)
    expected = [[57, 100], [56, 100], [55, 100]]
    assert_equal expected, snake.pixels
  end

  def test_pixels_of_snake_first_directed_left
    snake = Snake.new(100, 200, :left)
    expected = [[43, 100], [44, 100], [45, 100]]
    assert_equal expected, snake.pixels
  end

  def test_if_snake_is_three_pixels_on_create
    snake = Snake.new(100, 200)
    assert_equal 3, snake.pixels.size
  end

  def test_if_on_create_snake_is_defaultly_directed_right
    snake = Snake.new(100, 200)
    assert_equal :right, snake.direction
  end

  def test_if_snake_is_alive_on_create
    snake = Snake.new(100, 200)
    assert_equal true, snake.alive
  end

  def test_if_snake_is_not_alive_after_kill_method
    snake = Snake.new(100, 200)
    snake.kill
    assert_equal false, snake.alive
  end

  def test_pixel_at?
    snake = Snake.new(100, 200)
    0.upto(199) do |y|
      0.upto(99) do |x|
        if snake.pixels.include?([x, y])
          assert_equal true, snake.pixel_at?(x, y)
        else
          assert_equal false, snake.pixel_at?(x, y)
        end
      end
    end
  end

  def test_serialize
    snake = Snake.new(234, 123, :up, 3,
              [[1,0],[1,2],[2,2],[3,2],[3,3],[3,4]])
    expected = [234, 123, :up, 3,
              [[1,0],[1,2],[2,2],[3,2],[3,3],[3,4]]]
    assert_equal expected, snake.serialize
  end

  def test_if_defaultly_score_is_zero_on_create
    snake = Snake.new(123, 231, :down)
    assert_equal 0, snake.score
  end
end

class TestFood < Test::Unit::TestCase
  def test_if_food_is_located_on_zero_zero_when_created
    food = Food.new()
    assert_equal [0, 0], [food.x, food.y]
  end

  def test_food_at?
    food = Food.new()
    assert_equal true, food.food_at?(0, 0)
    assert_equal false, food.food_at?(rand(1..100), rand(1..200))
  end

  def test_set_food
    food = Food.new()
    assert_equal true, food.food_at?(0, 0)
    x, y = rand(1..100), rand(1..200)
    food.set_food(x, y)
    assert_equal true, food.food_at?(x, y)
    assert_equal false, food.food_at?(x-1, y)
  end

  def test_food_serialize
    food = Food.new()
    x, y = rand(1..1122), rand(1..2032)
    food.set_food(x, y)
    assert_equal [x, y], food.serialize
    food = Food.new()
    assert_equal [0, 0], food.serialize
  end
end

class TestMap < Test::Unit::TestCase
  def test_map_with_no_walls
    map = Map.new('map')
    assert_equal true, map.pixels.empty?
  end

  def test_if_width_is_calculated_properly
    map = Map.new('map')
    lines = File.open('./Maps/map.vmp').to_a
    expected = lines.first.size.pred
    assert_equal expected, map.width
  end

  def test_if_height_is_calculated_properly
    map = Map.new('map')
    lines = File.open('./Maps/map.vmp').to_a
    expected = lines.size
    assert_equal expected, map.height
  end

  def test_map_serialize
    map = Map.new('map')
    assert_equal ['map'], map.serialize
  end

  def test_map_serialize2
    map = Map.new('trivial')
    assert_equal ['trivial'], map.serialize
  end

  def test_map_name
    map = Map.new('trivial')
    assert_equal 'trivial', map.map_name
  end
end

class TestFrame < Test::Unit::TestCase
  def test_if_things_are_drawn_properly
    snake = Snake.new(100, 200, :up, 2, [[0, 1], [0, 2]])
    food = Food.new()
    x, y = rand(2..123), rand(2..223)
    food.set_food(x, y)
    map = Map.new('map')

    frame = Frame.new(map, food, snake)
    assert_equal true, frame.pixel_at?(0, 1)
    assert_equal true, frame.pixel_at?(0, 2)
    assert_equal true, frame.pixel_at?(x, y)
    assert_equal false, frame.pixel_at?(rand(x..x+100), rand(y..y+100))
  end

  def test_frame_pixel_at
    snake = Snake.new(57, 19, :up, 2, [[0, 1], [0, 2]])
    food = Food.new()
    x1, y1 = 5, 7
    food.set_food(x1, y1)
    map = Map.new('map')
    frame = Frame.new(map, food, snake)

    0.upto(19) do |y|
      0.upto(57) do |x|
        if [[0, 1], [0, 2], [x1 ,y1]].include?([x, y])
          assert_equal true, frame.pixel_at?(x, y)
        else
          assert_equal false, frame.pixel_at?(x, y)
        end
      end
    end
  end

  def test_draw_food
    snake = Snake.new(57, 19, :up, 2, [[0, 1], [0, 2]])
    food = Food.new()
    x, y = 4, 7
    food.set_food(x, y)
    map = Map.new('map')
    frame = Frame.new(map, food, snake)
    assert_equal 2, frame.pixels[[x, y]]
  end

  def test_draw_snake
    snake1 = Snake.new(57, 19, :up, 2, [[0, 1], [0, 2]])
    snake2 = Snake.new(57, 19, :up, 2, [[7, 1], [7, 2]])
    food = Food.new()
    x, y = 4, 7
    food.set_food(x, y)
    map = Map.new('map')
    frame = Frame.new(map, food, snake1, snake2)
    assert_equal 1, frame.pixels[[0, 1]]
    assert_equal 1, frame.pixels[[0, 2]]
    assert_equal 3, frame.pixels[[7, 1]]
    assert_equal 3, frame.pixels[[7, 2]]
  end

  def test_width_and_height
    snake1 = Snake.new(57, 19, :up, 2, [[0, 1], [0, 2]])
    snake2 = Snake.new(57, 19, :up, 2, [[7, 1], [7, 2]])
    food = Food.new()
    x, y = 4, 7
    food.set_food(x, y)
    map = Map.new('map')
    frame = Frame.new(map, food, snake1, snake2)
    assert_equal map.width, frame.width
    assert_equal map.height, frame.height
  end
end    

class TestAscii_render < Test::Unit::TestCase
  def test_pixel_at
    snake1 = Snake.new(57, 19, :up, 2, [[0, 1], [0, 2]])
    snake2 = Snake.new(57, 19, :up, 2, [[7, 1], [7, 2]])
    food = Food.new()
    x, y = 4, 7
    food.set_food(x, y)
    map = Map.new('map')
    frame = Frame.new(map, food, snake1, snake2)
    render = Ascii_render.new(frame)
    assert_not_equal render.send("blank_pixel"), render.send("pixel_at" [0, 1])
  end

  def test_if_symbols_are_different
    snake1 = Snake.new(57, 19, :up, 2, [[0, 1], [0, 2]])
    snake2 = Snake.new(57, 19, :up, 2, [[7, 1], [7, 2]])
    food = Food.new()
    x, y = 4, 7
    food.set_food(x, y)
    map = Map.new('map')
    frame = Frame.new(map, food, snake1, snake2)
    render = Ascii_render.new(frame)
    assert_not_equal render.send("blank_pixel"), render.send("char_snake2")
    assert_not_equal render.send("blank_pixel"), render.send("char_snake1")
    assert_not_equal render.send("blank_pixel"), render.send("char_wall")
    assert_not_equal render.send("blank_pixel"), render.send("char_food")
    assert_not_equal render.send("char_snake1"), render.send("char_snake2")
    assert_not_equal render.send("char_wall"), render.send("char_snake2")
    assert_not_equal render.send("char_wall"), render.send("char_snake1")
    assert_not_equal render.send("char_food"), render.send("char_snake2")
    assert_not_equal render.send("char_food"), render.send("char_snake1")
  end
end
class TestHighscore < Test::Unit::TestCase
end

class TestGame < Test::Unit::TestCase
  def test_is_there_second_snake_on_single_game
    map   = Map.new('map')
    food  = Food.new()
    snake_one = Snake.new(map.width, map.height)

    game = Game.new(false, map, food, snake_one)
    assert_equal nil, game.snake_two
  end

  def test_is_there_second_snake_on_multiplayer
    map   = Map.new('map')
    food  = Food.new()
    snake_one = Snake.new(map.width, map.height)
    snake_two = Snake.new(100, 200, :left)

    game = Game.new(true, map, food, snake_one, snake_two)
    assert_not_equal nil, game.snake_two
  end

  def test_if_on_create_game_isnt_paused
    map   = Map.new('map')
    food  = Food.new()
    snake_one = Snake.new(map.width, map.height)

    game = Game.new(false, map, food, snake_one)
    assert_equal false, game.paused
  end

  def test_if_collision_works
    map   = Map.new('map')
    food  = Food.new()
    snake_one = Snake.new(100, 200, :right, 0, [[4, 4], [4, 5], [4, 6]])
    snake_two = Snake.new(100, 200, :left, 0,[[4, 6],[4, 5],[4, 4]])

    game = Game.new(true, map, food, snake_one, snake_two)
    assert_not_equal false, game.collision?
    assert_equal false, snake_one.alive
    assert_equal false, snake_two.alive
  end

  def test_if_snake_has_biten_itself
    map   = Map.new('map')
    food  = Food.new()
    snake_one = Snake.new(100, 200, :right, 3, [[4, 4], [4, 5], [3, 5], [3, 4], [4, 4]])
    snake_two = Snake.new(100, 200, :left, 0,[[4, 6],[4, 5],[4, 4]])

    game = Game.new(true, map, food, snake_one, snake_two)

    assert_equal true, game.hits_self?(snake_one)
    assert_equal false, game.hits_self?(snake_two)
  end
  def test_pixel_at
    map   = Map.new('map')
    food  = Food.new()
    snake_one = Snake.new(100, 200, :right, 3, [[4, 4], [4, 5], [3, 5], [3, 4], [4, 4]])
    snake_two = Snake.new(100, 200, :left, 0,[[4, 6],[4, 5],[4, 4]])
    game = Game.new(true, map, food, snake_one, snake_two)
    assert_equal true, game.pixel_at?(4, 4)
    assert_equal true, game.pixel_at?(4, 5)
    assert_equal true, game.pixel_at?(3, 5)
    assert_equal true, game.pixel_at?(3, 4)
    assert_equal true, game.pixel_at?(4, 6)
    assert_equal true, game.pixel_at?(4, 5)
    assert_equal false, game.pixel_at?(4, 0)
    assert_equal false, game.pixel_at?(0, 4)
    assert_equal false, game.pixel_at?(5, 5)
    assert_equal false, game.pixel_at?(5, 4)
  end

  def test_get_free_pixel
    map   = Map.new('map')
    food  = Food.new()
    snake_one = Snake.new(100, 200, :right, 3, [[4, 4], [4, 5], [3, 5], [3, 4], [4, 4]])
    snake_two = Snake.new(100, 200, :left, 0,[[4, 6],[4, 5],[4, 4]])
    game = Game.new(true, map, food, snake_one, snake_two)
    0.upto(20) do |x|
      pixel = game.get_free_pixel
      assert_equal false, game.pixel_at?(pixel[0], pixel[1])
    end
  end
end