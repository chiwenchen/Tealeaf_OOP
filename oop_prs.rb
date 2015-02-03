class Player

  attr_accessor :name, :hand

  def initialize(n, h)
    @name = n
    @hand = h
  end

end

class Human < Player

  def pick_hand
    puts "pick either p)Paper, r)Rock, s)Scissors"
    self.hand = gets.chomp.downcase
    if Game_Engine::CHOICES.keys.include?(hand)
      return hand
    else
      pick_hand
    end
  end
  
end

class Computer < Player

  def pick_hand
    self.hand = Game_Engine::CHOICES.keys.sample
  end

end

class Game_Engine

  CHOICES = {"p" => "Paper","r" => "Rock","s" => "Scissors",}

  attr_reader :player, :computer

  def initialize
    @player = Human.new("chiwen", nil)
    @computer = Computer.new("P410", nil)
  end

  def compare
    if player.hand == computer.hand
      puts "It's a tie!"
    elsif (player.hand == "p" && computer.hand == "r") || (player.hand == "r" && computer.hand == "s") || (player.hand == "s" && computer.hand == "p")
      puts "#{player.name} win!!"
    else
      puts "#{computer.name} win!!"
    end
  end

  def show_msg(player)
    puts "#{player.name} picked #{CHOICES[player.hand]}"
  end

  def play
    begin
      system 'clear'
      player.pick_hand
      computer.pick_hand
      show_msg(player)
      show_msg(computer)
      compare
      puts "Play again? y)Yes n)No"
      play = gets.chomp.downcase
    end until play == "n"
    puts "Good-Bye"
  end

end

Game_Engine.new.play
