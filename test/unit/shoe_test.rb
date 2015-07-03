require 'test/unit'
%w[hand shoe card].each { |file| require File.dirname(__FILE__) + "/../../app/models/cards/#{file}"  }

# Ensures that the Shoe operates correctly
class ShoeTest < Test::Unit::TestCase

  def test_shoe_refreshes_when_empty
    shoe = Shoe.new
    (8 * 52 + 2).times do
      hand = shoe.new_player_hand
      assert hand.high_value > 0 && !hand.busted?
    end
  end
  
  def test_shoe_knows_when_to_refresh
    shoe = Shoe.new
    ((8 * 52) / 2 / 2).times { shoe.new_player_hand }  # 2 cards per hand, 1/2 cards played
    assert !shoe.needs_refreshing?
    shoe.new_player_hand
    assert shoe.needs_refreshing?
  end

end