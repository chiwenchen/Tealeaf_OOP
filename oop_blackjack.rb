class Player
  attr_accessor :own_card, :name, :score

  def initialize(given_name)
    @own_card = []
    @name = given_name
    @score = 0
  end

  def show_card
    puts "--- #{name} has ---"
    own_card.each {|card|puts card}
  end

  def count_score
    @score = 0
    card_value = []
    own_card.map do|card|
      if card.face_value == "A" 
        @score += 1
      elsif card.face_value.class == Fixnum
        @score += card.face_value
      else
        @score += 10
      end  
      card_value << card.face_value
    end
    self.score += 10 if score <= 11 && card_value.include?("A")
    score
  end

  def show_score
    puts "Total: #{count_score} point"
    puts ""
  end

  def busted?
    score > 21
  end

  def blackjack?
    score == 21
  end

end

class Dealer < Player

  attr_accessor :active

  def initialize(given_name)
    @active = false
    super(given_name)
  end

  def show_card
    puts "--- #{name} has ---"
    own_card.each do |card|
      if own_card.index(card) == 1 && active == false
        puts "Hidden card"
      else
        puts card
      end
    end
  end

  def hide_score
    puts "Total: Hidden"
    puts ""
  end

end

class Gamer < Player

end


class Deck

  attr_accessor :cards, :suits, :all_cards

  def initialize
    @all_cards = []
    @cards = ["A",2,3,4,5,6,7,8,9,10,"J","Q","K"]
    @suits = ['Heart-', 'Spades-', 'Diamonds-', 'Clubs-']
    @cards.each do |face_value|
      @suits.each do |suit|
        @all_cards << Card.new(suit, face_value)
      end
    end
  end

  def serve_card
   get_card_index = rand(all_cards.count) 
   all_cards.delete_at(get_card_index) #this will also return the deleted item
  end

end

class Card

  attr_accessor :suit, :face_value 

  def to_s
    "[#{suit} #{face_value}]"
  end

  def initialize(s, fv)
    @suit = s
    @face_value = fv
  end

end

class GameEngine
  attr_accessor :gamer, :dealer, :deck

  def initialize(player_name)
    puts "Hello, #{player_name}, Good to see you!"
    @gamer = Gamer.new(player_name)
    @dealer = Dealer.new("Dealer")
    @deck = Deck.new 
  end

  def show_hand
    system 'clear'
    gamer.show_card
    gamer.show_score
    dealer.show_card
    dealer.active ? dealer.show_score : dealer.hide_score
  end

  def start_game
    sleep 1
    puts "Game start!!"
    sleep 1
    system 'clear'
    gamer.own_card << @deck.serve_card
    gamer.own_card << @deck.serve_card
    dealer.own_card << @deck.serve_card
    dealer.own_card << @deck.serve_card
    show_hand

  end

  def player_turn
    while !gamer.busted? && !gamer.blackjack?
      begin
        puts "You wanna Stay or Hit. S)Stay H)Hit"
        gamer_choice = gets.chomp.upcase
      end until gamer_choice == "H" || gamer_choice == "S"
      if gamer_choice == "H"
        gamer.own_card << @deck.serve_card
        show_hand
      else
        break
      end
    end
  end

  def dealer_turn
    puts "Dealer's turn!"
    sleep 1
    show_hand
    while !dealer.busted? && !dealer.blackjack? && dealer.count_score < 17
      dealer.own_card << @deck.serve_card
      show_hand
      sleep 1
    end
  end

  def result
    case
    when gamer.busted?
      puts "#You busted!! #{gamer.name} lose"
    when gamer.blackjack?
      puts "Congras! You hit Blackjack!! #{gamer.name} won"
    when dealer.busted?
      puts "#{dealer.name} busted!! #{gamer.name} won!"
    when dealer.blackjack?
      puts "#{dealer.name} hit Blackjack!! #{gamer.name} lose"
    when dealer.count_score == gamer.count_score
      puts "IT's a TIE!"
    when dealer.count_score > gamer.count_score
      show_hand
      puts "#{dealer.name}'s score is greater than #{gamer.name}, you lose!"
    else
      show_hand
      puts "#{gamer.name}'s score is greater than #{dealer.name}, you won!"
   end
 end


  def play
    start_game
    player_turn
    if !gamer.busted? && !gamer.blackjack?
      dealer.active = true
      dealer_turn
    end
    result
  end

end

play_game = "Y"
game_round = 1
while play_game == "Y"
  system 'clear'
  puts "Welcome to Blackjack!!"
  sleep 1
  if game_round == 1
    puts "What's your name?"
    player_name = gets.chomp
    game_round += 1
  end
  GameEngine.new(player_name).play
  begin
    puts "Do you wanna play again? Y) Yes, N) No "
    play_game = gets.chomp.upcase
  end until play_game == "Y" || play_game == "N"
end 
puts "Good Bye"




