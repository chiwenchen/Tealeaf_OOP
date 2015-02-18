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
        self.score += 1
      elsif card.face_value.class == Fixnum
        self.score += card.face_value
      else
        self.score += 10
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
    true if score > 21
  end

  def blackjack?
    true if score == 21
  end

end

class Dealer < Player

  attr_accessor :dealer_turn

  def initialize(given_name)
    @dealer_turn = false
    super(given_name)
  end

  def show_card
    puts "--- #{name} has ---"
    own_card.each do |card|
      if own_card.index(card) == 1 && dealer_turn == false
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
    get_card_index = all_cards.index(all_cards.sample)
    get_card = all_cards[get_card_index]
    all_cards.delete_at(get_card_index)
    get_card
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

class Game_Engine
  attr_accessor :gamer, :dealer, :deck

  def initialize
    system 'clear'
    puts "Welcome to Blackjack!!"
    sleep 1
    puts "What's your name?"
    name = gets.chomp
    puts "Hello, #{name}, Good to see you!"
    @gamer = Gamer.new(name)
    @dealer = Dealer.new("Dealer")
    @deck = Deck.new 
    @@dealer_turn = false
  end

  def show_hand
    system 'clear'
    gamer.show_card
    gamer.show_score
    dealer.show_card
    dealer.dealer_turn ? dealer.show_score : dealer.hide_score
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
    while !dealer.busted? && !dealer.blackjack? && !(dealer.count_score >= 17)
      dealer.own_card << @deck.serve_card
      show_hand
      sleep 1
    end
  end

  def result
    if gamer.busted? || gamer.blackjack?
      puts "#You busted!! #{gamer.name} lose" if gamer.busted?
      puts "Congras! You hit Blackjack!! #{gamer.name} won" if gamer.blackjack?
    elsif dealer.busted? || dealer.blackjack?
      puts "#{dealer.name} busted!! #{gamer.name} won!" if dealer.busted?
      puts "#{dealer.name} hit Blackjack!! #{gamer.name} lose" if dealer.blackjack?
    elsif dealer.count_score == gamer.count_score
      puts "IT's a TIE!"
    elsif dealer.count_score > gamer.count_score
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
      self.dealer.dealer_turn = true
      dealer_turn
    end
    result
  end

end

play_game = "Y"
while play_game == "Y"
  Game_Engine.new.play
  begin
    puts "Do you wanna play again? Y) Yes, N) No "
    play_game = gets.chomp.upcase
  end until play_game == "Y" || play_game == "N"
end 
puts "Good Bye"




