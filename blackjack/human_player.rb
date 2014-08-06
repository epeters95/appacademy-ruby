require_relative 'player'

class HumanPlayer < Player
  def initialize
    puts "Enter your name: "
    name = gets.chomp
    puts "Enter your starting bankroll: "
    bankroll = gets.chomp.gsub(/\D/, '').to_i
    super(name, bankroll)
    system("clear")
  end
  
  def place_bet(dealer)
    puts "Enter your bet: "
    bet = gets.chomp.gsub(/\D/, '').to_i
    super(dealer, bet)
    system("clear")
  end
end