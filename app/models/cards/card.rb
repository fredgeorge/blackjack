# Understands the playable unit for Blackjack
class Card
  DENOMINATIONS = [:king, :queen, :jack, :ten, :nine, :eight, :seven, :six, :five, :four, :three, :two, :ace]
  SUITS = [:spades, :hearts, :diamonds, :clubs]
  VALUES = [10, 10, 10, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1]
  
  attr_reader :denomination
  
  def initialize(denomination)
    index = DENOMINATIONS.index(denomination)
    raise ArgumentError, "Unknown card denomination of '#{denomination}'", caller unless index
    @denomination = denomination
    @value = VALUES[index]
  end
  
  def value
    @value
  end
  
  def ace?
    @denomination == :ace
  end
  
  def to_s
    @denomination.to_s.capitalize
  end
  
  def self.deck
    SUITS.inject([]) do |cards, suit| 
      (cards << DENOMINATIONS.collect{|d| Card.new(d)}).flatten
    end
  end
  
end