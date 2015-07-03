require 'test/unit'
%w[hand shoe card].each { |file| require File.dirname(__FILE__) + "/../../app/models/cards/#{file}"  }

# Ensures that Hand recognizes Blackjack correctly
class HandBlackjackTest < Test::Unit::TestCase
  
  def test_hand_knows_blackjack
    [:king, :queen, :jack, :ten].each do |ten_card|
      shoe = Shoe.new ten_card, :ace
      assert shoe.new_player_hand.blackjack?
      shoe = Shoe.new :ace, ten_card
      assert shoe.new_player_hand.blackjack?
    end
  end
  
  def test_hand_knows_not_blackjack_with_ace
    [:nine, :eight, :seven, :six, :five, :four, :three, :two].each do |non_ten_card|
      shoe = Shoe.new non_ten_card, :ace
      assert !shoe.new_player_hand.blackjack?
      shoe = Shoe.new :ace, non_ten_card
      assert !shoe.new_player_hand.blackjack?
    end
  end
  
  def test_hand_knows_not_blackjack_without_ace
    [:king, :queen, :jack, :ten, :nine, :eight, :seven, :six, :five, :four, :three, :two].each do |first|
      [:king, :queen, :jack, :ten, :nine, :eight, :seven, :six, :five, :four, :three, :two].each do |second|
        shoe = Shoe.new first, second
        assert !shoe.new_player_hand.blackjack?
      end
    end
  end
end