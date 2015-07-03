# Understands a playing blackjack with a single set of cards for a player
class Hand
  WINNING_BOUNDARY = 21
  
  attr_reader :cards
  attr_writer :cards
  attr_reader :split_hand
  
  def initialize(shoe)
    @shoe = shoe
    @cards = [shoe.deal, shoe.deal]
  end
  
  def describe
    result = "#{(@cards.collect { |card| card.to_s }).join(', ')} (total #{high_value})"
    result << " Blackjack!" if blackjack?
    result << " %$&*@ busted %$&*@" if busted?
    result
  end
  
  def high_value
    result = low_value
    return result if result > 11  # boosting an ace would bust the hand
    (@cards.any? {|card| card.ace?}) ? result + 10 : result
  end
  
  def low_value
    @cards.inject(0) { |sum, card| sum + card.value }
  end
  
  def hit_me!
    @cards << card = @shoe.deal
    [["Dealt a(n) #{card.to_s}.  Now hold #{describe}"], actions]
  end
  
  def stand!
    @stand = true
    [["Stand with #{describe}"], actions]
  end
  
  def split!
    raise "Split not allowed unless only two cards with matching denominations" unless split?
    messages = ['Splitting hand...']
    @split_hand = self.clone
    @split_hand.cards = [@cards.pop]
    messages << "Each hand now has one #{@cards.first.to_s}"
    first_hand_messages, actions = self.hit_me!
    messages << "Original hand: #{first_hand_messages.first}"
    split_hand_messages, ignore = @split_hand.hit_me!
    messages << "Split hand: #{split_hand_messages.first}"
    [messages, actions]
  end
  
  def double_down!
    raise "Double down not allowed if you have already been hit" unless double_down?
    hit_me_messages, ignore = hit_me!
    ignore, actions = stand!
    [(['Bet doubled.  Taking only one more card.'] << hit_me_messages).flatten, actions]
  end
  
  def blackjack?
    @cards.length == 2 && twenty_one?
  end
  
  def twenty_one?
    high_value == WINNING_BOUNDARY
  end
  
  def busted?
    low_value > WINNING_BOUNDARY
  end
  
  def split?
    @cards.length == 2 && @cards.first.denomination == @cards.last.denomination
  end
  
  def double_down?
    @cards.length == 2
  end
  
  def actions
    return [] if @stand
    return [] if twenty_one?
    return [] if busted?
    results = [ Action.hit_me(self), Action.stand(self) ]
    results << Action.split(self) if split?
    results << Action.double_down(self) if double_down?
    results.sort!
  end
  
  def payout(dealer_hand)
    return 0 if blackjack? && dealer_hand.blackjack?
    return 1.5 if blackjack?
    return -1 if dealer_hand.blackjack?
    return -1 if busted?
    return 1 if dealer_hand.busted?
    high_value <=> dealer_hand.high_value
  end
  
end