require_relative 'dealer'
require_relative 'human_player'
require 'io/console'

class Game
  def initialize(num_players)
    @deck = Deck.new
    @dealer = Dealer.new
    @players = []
    system("clear")
    num_players.times do |i|
      puts "Player #{i + 1}"
      @players << HumanPlayer.new
    end
    play_round
  end
  
  def play_round
    @deck.shuffle!
    system("clear")
    collect_bets
  
    @players.each do |player|
      choice = ""
      msg = ""
      until choice == "stand" || player.hand.busted?
        system("clear")
        puts "#{player.name}'s hand: #{player.hand}"
        puts msg
        puts "Hit or stand?"
        choice = gets.chomp.downcase
        case choice
        when "hit"
          player.hand.hit(@deck)
          if player.hand.busted?
            system("clear")
            puts "#{player.name}'s hand: #{player.hand}"
            puts "Busted! \nPress space to continue..."
            loop until STDIN.getch == ' '
          else
            msg = ""
          end
        when "stand"
          break
        else
          msg = "Invalid answer"
        end
      end
    end
    system("clear")
    @dealer.hand = Hand.deal_from(@deck)
    @dealer.play_hand(@deck)
    puts "Dealer's hand: #{@dealer.hand}\n"
    puts "Dealer busted!" if @dealer.hand.busted?
    puts
    @players.each { |player| puts "#{player.name}'s hand: #{player.hand}" }
    puts
    @dealer.pay_bets
    @players.select { |pl| pl.bankroll == 0 }.each do |player|
      puts "#{player.name} is out of money!"
      @players.delete(player)
      @dealer.take_bet(player, 0)
    end
    @players.each { |player| player.hand.return_cards(@deck) }
    if @players.any? { |player| player.bankroll != 0 }
      puts "Play again? (y/n) "
      (STDIN.getch == 'y' ? play_round : return)
    end
  end
  
  private
  
  def collect_bets
    @players.each do |player|
      puts "The dealer will collect bets now. \n"
      puts "#{player.name} - $#{player.bankroll} in bank"
      valid_bet = false
      until valid_bet
        begin
          player.place_bet(@dealer)
        rescue RuntimeError => e
          puts "Can't cover that bet! Try again"
        else
          valid_bet = true
        end
      end
      player.hand = Hand.deal_from(@deck)
    end
  end
  
end

Game.new(2)









