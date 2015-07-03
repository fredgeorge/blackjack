require 'test/unit'
%w[hand shoe card].each { |file| require File.dirname(__FILE__) + "/../../app/models/cards/#{file}"  }

# Ensures that Hand counts its value correctly
class HandValueTest < Test::Unit::TestCase
  
  def test_hand_count_without_aces
    assert_value 13, :three, :ten
    assert_value 20, :king, :ten
    assert_value 20, :ten, :jack
    assert_value 13, :three, :queen
  end
  
  def test_counting_with_aces
    assert_high_low 12, 2, :ace, :ace
    assert_high_low 21, 11, :ten, :ace
    assert_high_low 21, 11, :ace, :king
    assert_high_low 20, 10, :ace, :nine
  end
  
  private
  
    def assert_value(expected, *card_names)
      assert_high_low(expected, expected, *card_names)
    end
  
    def assert_high_low(expected_high, expected_low, *card_names)
      shoe = Shoe.new *card_names
      hand = shoe.new_player_hand
      assert_equal expected_high, hand.high_value, "Unexpected high value of #{hand.high_value}"
      assert_equal expected_low, hand.low_value, "Unexpected low value of #{hand.low_value}"
    end
  
end