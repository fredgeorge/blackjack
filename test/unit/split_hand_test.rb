require "test/unit"
%w[hand shoe card].each { |file| require File.dirname(__FILE__) + "/../../app/models/cards/#{file}"  }
%w[action].each { |file| require File.dirname(__FILE__) + "/../../app/models/game/#{file}"  }

# Ensures that Hands can be split appropriately
class SplitHandTest < Test::Unit::TestCase
  
  def test_splitting_allowed
    assert hand(:ten, :ten).split?
    assert hand(:ace, :ace).split?
    assert hand(:four, :four).split?
    assert !hand(:jack, :ten).split?
    hand = hand(:three, :three, :three)
    assert hand.split?
    hand.hit_me!
    assert !hand.split?
  end
  
  def test_split
    first_hand = hand :eight, :eight, :ten, :four
    assert first_hand.split?
    assert_equal 16, first_hand.high_value
    second_hand = split_hand first_hand
    assert_equal 18, first_hand.high_value
    assert !first_hand.split?
    assert_equal 12, second_hand.high_value
    assert !second_hand.split?
  end
  
  def test_split_of_splits
    first = hand :eight, :eight, :eight, :eight, :eight, :nine, :ten, :jack, :ace, :four
    second = split_hand first
    third = split_hand first
    fourth = split_hand second
    fifth = split_hand first
    # done with eights
    [first, second, third, fourth, fifth].each { |hand| assert !hand.split?  }
  end
   
  private
  
    def hand(*denominations)
      shoe = Shoe.new *denominations
      shoe.new_player_hand
    end
    
    def split_hand(original)
      original.split!
      original.split_hand
    end
  
end