require 'test/unit'
%w[hand shoe card].each { |file| require File.dirname(__FILE__) + "/../../app/models/cards/#{file}"  }

# Ensures that Hand understands when busted
class HandBustedTest < Test::Unit::TestCase
  
  def test_hand_count_without_aces
    assert_bust 3, :eight, :seven, :seven
    assert_bust 4, :seven, :seven, :six, :two
  end
  
  def test_hand_count_with_aces
    assert_bust 6, :ace, :nine, :nine, :ace, :ace, :ace
    assert_bust 22, *Array.new(22, :ace)
  end
  
  private
  
    def assert_bust(expected_bust_count, *card_names)
      shoe = Shoe.new *card_names
      hand = shoe.new_player_hand
      (3..(expected_bust_count - 1)).each do
        hand.hit_me!
        assert !hand.busted?, "Busted early with #{hand}"
      end  
      hand.hit_me!
      assert hand.busted?, "Did not bust with #{hand}"
    end
  
end