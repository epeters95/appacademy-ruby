require_relative 'deck'

class Hand
  # This is called a *factory method*; it's a *class method* that
  # takes the a `Deck` and creates and returns a `Hand`
  # object. This is in contrast to the `#initialize` method that
  # expects an `Array` of cards to hold.
  def self.deal_from(deck)
    Hand.new(deck.take(2))
  end

  attr_accessor :cards

  def initialize(cards)
    @cards = cards
  end

  def points
    aces = 0
    value = @cards.map do |card|
      begin
        card.blackjack_value
      rescue StandardError => e
        aces += 1
        11
      end
    end.inject(&:+)
    aces.times { value -= 10 if value > 21 }
    value
  end

  def busted?
    points > 21 unless points.nil?
  end

  def hit(deck)
    raise "already busted" if busted?
    @cards += deck.take(1)
  end

  def beats?(other_hand)
    return false if busted?
    return true if other_hand.busted?
    points > other_hand.points    
  end
  
  def ==(other_hand)
    points == other_hand.points
  end

  def return_cards(deck)
    deck.return(@cards)
    @cards = []
  end

  def to_s
    @cards.join(",") + " (#{points})"
  end
end

