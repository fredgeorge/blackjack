require 'test/unit'
%w[hand shoe card].each { |file| require File.dirname(__FILE__) + "/../../app/models/cards/#{file}"  }

# Ensures that two Hands can determine the proper payout (as fraction of original bet)
class HandPayoutTest < Test::Unit::TestCase

  def test_compare_two_non_blackjack_hands
    assert_payout -1, [:ten, :three], [:ace, :seven]
    assert_payout 1, [:ten, :three, :six], [:ace, :seven]
    assert_payout 0, [:ten, :three, :six], [:ace, :eight]
    assert_payout 0, [:ten, :three, :six], [:ace, :eight, :king]
  end
  
  def test_compare_with_blackjacks
    assert_payout -1, [:ten, :ten, :ace], [:ace, :jack]
    assert_payout 1.5, [:ace, :jack], [:ten, :ten, :ace]
    assert_payout 0, [:king, :ace], [:ace, :ten]
  end
  
  def test_compare_with_busted
    assert_payout -1, [:ten, :ten, :two], [:ace, :jack]
    assert_payout 1.5, [:ace, :jack], [:ten, :ten, :two]
    assert_payout -1, [:ten, :ten, :two], [:ten, :jack]
    assert_payout -1, [:ten, :ten, :two], [:three, :ten, :jack]
  end
  
  private
  
    def assert_payout(expected, players_cards, dealers_cards)
      player = hand(players_cards)
      dealer = hand(dealers_cards)
      assert_equal expected, player.payout(dealer), "Unexpected outcome between player with #{players_cards} and dealer with #{dealers_cards}"
    end
    
    def hand(denominiatons)
      shoe = Shoe.new *denominiatons
      result = shoe.new_player_hand
      (3..denominiatons.length).each { result.hit_me! }
      result
    end

end