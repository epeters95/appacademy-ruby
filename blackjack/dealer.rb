require_relative 'player'
require_relative 'hand'

class Dealer < Player
  attr_reader :bets

  def initialize
    super("dealer", 0)

    @bets = {}
  end

  def place_bet(dealer, amt)
    raise "Dealer doesn't bet"
  end

  def play_hand(deck)
    while hand.points < 17
      hand.hit(deck)
    end
  end

  def take_bet(player, amt)
    @bets[player] = amt
  end

  def pay_bets
    winners = @bets.keys.select { |player| player.hand.beats?(hand) }
    ties = @bets.keys.select { |player| player.hand == hand }
    losers = @bets.keys.select { |player| !winners.include?(player) }
    winners.each do |winner|
      amount = @bets[winner]*2
      winner.pay_winnings(amount)
      puts "#{winner.name} won $#{amount}"
    end
    ties.each do |tie|
      amount = @bets[tie]
      tie.pay_winnings(amount)
      puts "#{tie.name} tied for $#{amount}"
    end
    losers.each do |loser|
      puts "#{loser.name} lost $#{@bets[loser]}"
    end
  end
end
