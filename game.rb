require './snake'
require './food'
require './map'
require 'curses'
include Curses      
require './render'


def key_pressed?(snake)
  case getch
    when ?Q, ?q
      exit
    when ?W, ?w
      snake.direction = :up unless snake.direction.eql?(:down)
    when ?S, ?s
      snake.direction = :down unless snake.direction.eql?(:up)
    when ?D, ?d
      snake.direction = :right unless snake.direction.eql?(:left)
    when ?A, ?a
      snake.direction = :left unless snake.direction.eql?(:right)
    when ?P, ?p
      snake.paused = snake.paused ? false : true
  end
  close_screen
end

def is_paused?(snake)
  key_pressed?(snake)
  if snake.paused
    sleep(0.5)      
    is_paused?(snake)
  end
end

def start_game
  #init_screen
  #nocbreak
  #crmode
  #noecho           #does not show input of getch
  stdscr.nodelay = 1      #the getch doesnt system_pause while waiting for instructions
  #curs_set(0)         #the cursor is invisible.
  
  #system "clear"

  map   = Map.new('map2')
  food  = Food.new()
  snake = Snake.new(map, food)

  while(true)
    system "clear"
    is_paused?(snake)
    snake.move!
    snake.collision?

    render = Ascii_render.new(Frame.new(map, snake, food))
    
    puts render.render
    sleep(1.0/4.0)
    system "clear"
  end
  
end

start_game
