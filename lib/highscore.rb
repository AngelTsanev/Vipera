class Player
  attr_reader :name, :score

  def initialize(name, score)
    @name = name
    @score = score
  end

  def inspect
    "   " + @name + " -> " + @score.to_s
  end
end


def read_new_score(score, player)
  puts "Enter your nickname, player " + player.to_s + " : "
  name = STDIN.gets.chomp
  Player.new(name, score)
end

def read_all_highscores
  highscores = []
  File.open("./../Highscores/highscores.txt", 'r') do |file|
    while name = file.gets
      name = name[0...-1]
      score  = file.gets
      highscores.insert(-1, Player.new(name, score.to_i))
    end
  end
  highscores
end

def print_highscores
  system "clear"
  close_screen
  highscores = read_all_highscores
  puts "Highscores :"
  0.upto(highscores.size.pred) do |i|
    p highscores[i]
  end
end

def save_new_highscores(score_one, score_two)
  highscores = read_all_highscores
  new_score = read_new_score(score_one, 1)
  highscores.insert(-1, new_score)
  if score_two != -1
    new_score = read_new_score(score_two, 2)
    highscores.insert(-1, new_score)
  end

  highscores.sort_by!(&:score).reverse!
  open('./../Highscores/highscores.txt', 'w') do |file|
    0.upto([10, highscores.size].min.pred) do |entry|
      file << highscores[entry].name + "\n"
      file << highscores[entry].score.to_s + "\n"
    end
  end
end
