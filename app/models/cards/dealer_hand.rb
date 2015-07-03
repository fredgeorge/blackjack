# Understands a playable set of cards for the dealer
class DealerHand < Hand

  alias full_describe describe
  def describe
    "#{cards.first.to_s} showing"
  end
  
  def play
    messages = ["Dealer has #{full_describe}"]
    while !busted? && high_value < 17
      @cards << card = @shoe.deal
      messages << "Dealer takes a card. It's a(n) #{card.to_s}. Dealer now holds #{full_describe}"
    end
    messages
  end
  
end