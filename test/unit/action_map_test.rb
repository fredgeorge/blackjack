require "test/unit"
%w[shoe hand card].each { |file| require File.dirname(__FILE__) + "/../../app/models/cards/#{file}" }
%w[game action game_complete player].each { |file| require File.dirname(__FILE__) + "/../../app/models/game/#{file}" }

# Ensures that a map of letter => Actions is created properly
class ActionMapTest < Test::Unit::TestCase
  
  def test_map_valid_for_each_action
    game = Game.new
    @map = Action.letter_map [Action.quit, Action.number_of_players(game)]
    assert_entry :quit, 'Q'
    assert_entry :number_of_players, 'N'
  end
  
  private
  
    def assert_entry(expected_action, letter)
      action = @map[letter]
      assert_not_nil action, "No action found for #{letter}"
      assert_equal expected_action, @map[letter].name
    end
  
end
