require './../lib/snake'
require './../lib/food'
require './../lib/map'
require 'curses'
include Curses
require './../lib/render'
require './../lib/highscore'
require './../lib/food_and_snake_helpers'
include Food_and_Snake

class Game
  attr_accessor :multiplayer
  attr_reader :paused, :snake_one, :snake_two, :map, :food,
              :width, :height

  def initialize(multiplayer, map, food, snake_one, snake_two=nil)
    @multiplayer = multiplayer
    @paused = false
    @map = map
    @width = map.width
    @height = map.height
    @food = food
    @snake_one = snake_one
    @snake_two = nil
    @snake_two = snake_two if multiplayer
    if (food.x == 0 and food.y == 0)
      make_food
    end
  end

  module Food_and_Snake
  end

  def key_pressed?
    case getch
      when ?Q, ?q
        exit
      when ?W, ?w
        @snake_one.direction = :up unless @snake_one.direction.eql?(:down)
      when ?I, ?i
        if @multiplayer
          @snake_two.direction = :up unless @snake_two.direction.eql?(:down)
        end
      when ?S, ?s
        @snake_one.direction = :down unless @snake_one.direction.eql?(:up)
      when ?K, ?k
        if @multiplayer
          @snake_two.direction = :down unless @snake_two.direction.eql?(:up)
        end
      when ?D, ?d
        @snake_one.direction = :right unless @snake_one.direction.eql?(:left)
      when ?L, ?l
        if @multiplayer
          @snake_two.direction = :right unless @snake_two.direction.eql?(:left)
        end
      when ?A, ?a
        @snake_one.direction = :left unless @snake_one.direction.eql?(:right)
      when ?J, ?j
        if @multiplayer
          @snake_two.direction = :left unless @snake_two.direction.eql?(:right)
        end
      when ?X, ?x
        if @multiplayer
          save_game([true, @snake_one.serialize, @snake_two.serialize,
                     @map.serialize, @food.serialize])
        else
          save_game([false, @snake_one.serialize,
                     @map.serialize, @food.serialize])
        end
      when ?P, ?p
        @paused = @paused ? false : true
    end
    close_screen
  end

  def is_paused?
    key_pressed?
    key_pressed?
    if @paused
      render_with_score
      sleep(0.5)
      system "clear"
      is_paused?
    end
  end

  def save_game(array)
    system "clear"
    close_screen
    puts "Enter name for the save:"
    save_name = STDIN.gets.chomp
    stdscr.nodelay = 1
    File.open("./Saves/" + save_name + ".vsv", "wb") do |file|
      Marshal.dump(array, file)
    end
  end

  def render_with_score
    render = Ascii_render.new(Frame.new(@map, @food, @snake_one, @snake_two))
    if @multiplayer
      offset = snake_one.score.to_s.size + snake_two.score.to_s.size + 24
      puts 'Player 1 : ' + @snake_one.score.to_s + ' ' + '='*(@width-offset) +
           ' Player 2 : ' + @snake_two.score.to_s
    else
      score = @snake_one.score
      puts '='*(@width-(score.to_s.size+9)) + " Score : " + score.to_s
    end
    puts render.render
  end

  def end_game
    system "clear"
    close_screen
    if @multiplayer
      save_new_highscores(snake_one.score, snake_two.score)
    else
      save_new_highscores(snake_one.score, -1)
    end
    system "clear"
    if @multiplayer
      if !@snake_one.alive and @snake_two.alive
        puts "Player 2 wins!"
      end
      if !@snake_one.alive and !@snake_two.alive
        puts "Draw!"
      end
      if @snake_one.alive and !@snake_two.alive
        puts "Player 1 wins!"
      end
      sleep(3)
    end
  end

  def start_game
    stdscr.nodelay = 1

    while(true)
      system "clear"
      is_paused?

      make_snake_crawl(@snake_one)
      if @multiplayer
        make_snake_crawl(@snake_two)
      end

      if collision?
        end_game
        break
      end

      render_with_score

      sleep(1.0/4.0)
      system "clear"
    end
  end
end


def welcome
  system "clear"
  0.upto(25) do |i|
    if i == 12
      puts '-'*(70/2-9) + 'Welcome to Vipera!' + '-'*(70/2-9)
    else
      puts '-'*70
    end
  end
  sleep(2)
  menu
end

def menu
  stdscr.nodelay = 1

  while(true)
    keypress_menu
    print_menu
    sleep(0.5)

    system "clear"
  end
end

def keypress_menu
  case getch
    when ?1
      print_highscores
      sleep(5)
    when ?2
      load_saved_game
    when ?3
      start_single_game
    when ?4
      start_multiplayer_game
    when ?5
      exit
  end
  close_screen
end

def print_menu
  system "clear"
  puts "Choose :"
  puts "-> 1. Highscores."
  puts "-> 2. Load saved game."
  puts "-> 3. Play single game."
  puts "-> 4. Play multiplayer."
  puts "-> 5. Exit."
end

def load_saved_game
  system "clear"
  close_screen
  puts "Enter the name of the save:"
  save_name = STDIN.gets.chomp

  array = []
  File.open("./Saves/" + save_name + ".vsv","rb") do |file|
    array = Marshal.load(file)
  end
  multiplayer = array[0]
  if multiplayer
    map = Map.new(array[3][0])
    food = Food.new()
    food.set_food(array[4][0], array[4][1])
    snake_one = Snake.new(array[1][0], array[1][1],
                           array[1][2], array[1][3],
                           array[1][4])

    snake_two = Snake.new(array[2][0], array[2][1],
                           array[2][2], array[2][3],
                           array[2][4])
  else
    map = Map.new(array[2][0])
    food = Food.new()
    food.set_food(array[3][0], array[3][1])
    snake_one = Snake.new(array[1][0], array[1][1],
                           array[1][2], array[1][3],
                           array[1][4])
  end
  game = Game.new(multiplayer, map, food, snake_one, snake_two)
  game.start_game
end

def start_single_game
  system "clear"
  close_screen
  puts "Enter name of the map :"
  map_name = STDIN.gets.chomp

  map   = Map.new(map_name)
  food  = Food.new()
  snake_one = Snake.new(map.width, map.height)

  game = Game.new(false, map, food, snake_one)
  game.start_game
end

def start_multiplayer_game
  system "clear"
  close_screen
  puts "Enter name of the map :"
  map_name = STDIN.gets.chomp

  map   = Map.new(map_name)
  food  = Food.new()
  snake_one = Snake.new(map.width, map.height)
  snake_two = Snake.new(map.width, map.height, direction=:left)
  game = Game.new(true, map, food, snake_one, snake_two)
  game.start_game
end