# Understands the set of unplayed Cards.  Automatically refills on need.
class Shoe
  DECKS_PER_SHOE = 8
  REFRESH_THRESHOLD = 0.5
  
  def initialize(*seed_cards)
    @cards = new_shuffled_decks
    @cards.insert(0, *seed_cards.collect { |card_name| Card.new(card_name) })
  end
  
  def new_player_hand
    Hand.new(self)
  end
  
  def new_dealer_hand
    DealerHand.new(self)
  end
  
  def deal
    @cards = new_shuffled_decks if @cards.empty?
    @cards.shift
  end
  
  def needs_refreshing?
    @cards.length < (DECKS_PER_SHOE * 52) * REFRESH_THRESHOLD
  end
  
  private
  
    def new_shuffled_decks
      result = []
      DECKS_PER_SHOE.times { result << Card.deck }
      result.flatten!
      result.sort_by { |i| rand }
    end
  
end