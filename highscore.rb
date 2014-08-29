class Player
  attr_reader :name, :score

  def initialize(name, score)
    @name = name
    @score = score
  end

  def inspect
    @name + " -> " + @score.to_s
  end
end


def read_new_score(score)
  puts "Enter your Nickname :"
  name = gets.chomp
  Player.new(name, score)
end

def read_all_highscores
  highscores = []
  File.open("./Highscores/highscores.txt", 'r') do |file|  
  while name = file.gets
    name = name[0...-1] 
    score  = file.gets
    highscores.insert(-1, Player.new(name, score.to_i))
  end
  #p highscores.sort_by!(&:score).reverse!
  highscores
end  

end

def save_ten_top_highscores()
  new_score = read_new_score(192)
  highscores = read_all_highscores
  highscores.insert(-1, new_score)
  highscores.sort_by!(&:score).reverse!
  open('./Highscores/highscores.txt', 'w') do |file|
    0.upto([10, highscores.size].min.pred) do |entry|
      file << highscores[entry].name + "\n"
      file << highscores[entry].score.to_s + "\n"
    end
  end
end

save_ten_top_highscores