require 'pry'

class Player

  attr_accessor :name, :faction, :square

  def initialize(name, faction)
    @name = name
    @faction = faction
    @square = nil
  end

end

class Human < Player

  def pick_square
    puts "Pick a avialiable square (1 ~ 9)"
    self.square = gets.chomp.to_i
  end

end

class Computer < Player

end

class Table

  attr_accessor :table

  def initialize
    @table = {1 => " ",2 => " ",3 =>  " ",4 =>  " ",5 =>  " ",6 =>  " ",7 =>  " ",8 =>  " ",9 =>  " "}
  end

  def draw
    system 'clear'
    puts "   |   |    "
    puts " #{table[1]} | #{table[2]} |  #{table[3]} "
    puts "   |   |    "
    puts "---+---+----"
    puts "   |   |    "
    puts " #{table[4]} | #{table[5]} |  #{table[6]} "
    puts "   |   |    "
    puts "---+---+----"
    puts "   |   |    "
    puts " #{table[7]} | #{table[8]} |  #{table[9]} "
    puts "   |   |    "
  end

  def square_empty
    table.select{|position,value|value == ' '}.keys #array
  end

end

class Game_Engine

  WIN = [[1,4,7],[2,5,8],[3,6,9],[1,2,3],[4,5,6],[7,8,9],[1,5,9],[3,5,7]]

  attr_reader :player, :computer, :board
  attr_accessor :current_player, :occupy

  def initialize

    @player = Human.new('chiwen', 'X')
    @computer = Computer.new('T320', 'O')
    @board = Table.new
    @current_player = @player
    @occupy = []
  end

  def switch_player
    if @current_player == @player
      self.current_player = @computer
    else
      self.current_player = @player
    end
  end

  def win?
    @occupy = @board.table.select{|key, square|square == @current_player.faction}.keys
    WIN.each do |win_line|
      if (win_line & @occupy).count == 3
        return @current_player.name 
      end
    end
    nil
  end
      

  def play
    @board.draw
    begin
      if @current_player == @player
        begin
        @current_player.pick_square
        end until @board.square_empty.include?(@current_player.square) #square_empty returns array of position of all empty square
      else
        @current_player.square = @board.square_empty.sample #computer's turn
      end
      board.table[@current_player.square] = @current_player.faction
      @board.draw
      break if win?
      switch_player
    end until @board.square_empty == [] 
    if win?
      puts "winner is #{win?}"
    else
      puts "It's a tie!"
    end
  end
end

Game_Engine.new.play



