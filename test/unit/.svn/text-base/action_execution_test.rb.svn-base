require 'test/unit'
%w[hand shoe card].each { |file| require File.dirname(__FILE__) + "/../../app/models/cards/#{file}" }
require File.dirname(__FILE__) + "/../../app/models/game/action"

# Ensures that the various Actions on Hand work as expected
class ActionExecutionTest < Test::Unit::TestCase
  
  def setup
    @shoe = Shoe.new :five, :six, :seven, :eight
    @hand = @shoe.new_player_hand
  end
  
  def test_hit_me_action
    assert_equal 11, @hand.high_value
    action(:hit_me).execute
    assert_equal 18, @hand.high_value
    assert_equal 2, @hand.actions.length
    action(:hit_me).execute
    assert_equal 26, @hand.high_value
    assert_equal 0, @hand.actions.length
  end
  
  def test_stand
    assert_equal 11, @hand.high_value
    assert_equal 3, @hand.actions.length
    action(:stand).execute
    assert_equal 11, @hand.high_value
    assert_equal 0, @hand.actions.length
  end
  
  def test_split
    shoe = Shoe.new :eight, :eight, :ten, :two
    @hand = shoe.new_player_hand
    assert_equal 4, @hand.actions.length
    messages, actions = action(:split).execute
    assert_equal 4, messages.length, messages.inspect
    assert_equal 3, actions.length, actions.inspect
    second_hand = @hand.split_hand
    assert_equal 18, @hand.high_value
    assert_equal 10, second_hand.high_value
  end
  
  def test_double_down
    shoe = Shoe.new :four, :six, :king
    @hand = shoe.new_player_hand
    assert_equal 3, @hand.actions.length
    assert_equal 10, @hand.high_value
    action(:double_down).execute
    assert_equal 0, @hand.actions.length # can take one and only one hit
    assert_equal 20, @hand.high_value
  end
  
  def test_split_and_double_down_available
    shoe = Shoe.new :eight, :eight
    @hand = shoe.new_player_hand
    assert_equal 4, @hand.actions.length
    assert_not_nil action(:split)
    assert_not_nil action(:double_down)
  end
  
  private
  
    def action(name)
      @hand.actions.find { |a| a.name == name }
    end
  
end
