require 'test/unit'
%w[hand dealer_hand shoe card].each { |file| require File.dirname(__FILE__) + "/../../app/models/cards/#{file}"  }
require File.dirname(__FILE__) + "/../../app/models/game/action"

# Ensures that the special DealerHand variants work correctly
class DealerHandActionTest < Test::Unit::TestCase
  
  def test_dealer_must_hit_under_17
    shoe = Shoe.new :ten, :five, :ace, :ace, :two
    hand = shoe.new_dealer_hand
    assert_equal 15, hand.high_value
    messages = hand.play
    assert_equal 17, hand.high_value
  end
  
  def test_dealer_treats_ace_as_high_if_possible
    shoe = Shoe.new :ace, :five, :two, :three
    hand = shoe.new_dealer_hand
    assert_equal 16, hand.high_value
    messages = hand.play
    assert_equal 18, hand.high_value
  end
  
  def test_dealer_can_bust
    shoe = Shoe.new :king, :six, :king
    hand = shoe.new_dealer_hand
    assert_equal 16, hand.high_value
    messages = hand.play
    assert hand.busted?
    assert_equal 26, hand.high_value
  end
  
end
