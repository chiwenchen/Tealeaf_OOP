class MyCar

  attr_accessor :color
  attr_reader :year

  def self.gas_mileage(gas, mileage)
    puts "#{gas / mileage} gas per mileage"
  end

  def initialize(year, model, color)
    @year = year
    @model = model
    @color = color
    @current_speed = 0
  end

  def speed_up(number)
    @current_speed += number
    puts "Your car is speed up to #{@current_speed}"
  end

  def spray_paint(colour)
    puts "What color you want to paint on your car?"
    self.color = colour
    puts "Your car is now become #{color}"
  end
  
end

audi = MyCar.new(2015, "A6", "Red")
audi.speed_up(100)
audi.color = "Black"
puts "your car is now paint to #{Audi.color}"
puts "your car is made in #{Audi.year}"
audi.spray_paint("Sliver")
