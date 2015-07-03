require "test/unit"
%w[shoe hand card].each { |file| require File.dirname(__FILE__) + "/../../app/models/cards/#{file}" }
%w[game action game_complete player].each { |file| require File.dirname(__FILE__) + "/../../app/models/game/#{file}" }

# Ensures that initial variables can be established prior to start of play
class GameSetupTest < Test::Unit::TestCase
  
  def test_game_start
    game = Game.new
    messages, @actions = game.start
    assert_equal 4, messages.length
    assert_equal 3, @actions.length
    assert_actions :quit, :number_of_players, :start_betting
  end
  
  def test_setting_number_of_players
    game = Game.new
    assert_equal 6, game.number_of_players
    messages, @actions = Action.number_of_players(game).execute(4)
    assert_equal 4, game.number_of_players
    assert_equal 1, messages.length
    assert_equal 3, @actions.length
  end
  
  def test_rejecting_invalid_number_of_players
    game = Game.new
    assert_equal 6, game.number_of_players
    Action.number_of_players(game).execute(9)
    assert_equal 6, game.number_of_players
    Action.number_of_players(game).execute(0)
    assert_equal 6, game.number_of_players
    Action.number_of_players(game).execute(-14)
    assert_equal 6, game.number_of_players
    Action.number_of_players(game).execute('none')
    assert_equal 6, game.number_of_players
  end
  
  def test_quitting_the_game
    assert_raise(GameComplete) { Action.quit.execute  }
  end
  
  private
  
    def assert_actions(*expected_actions)
      expected_actions.each do |expected| 
        assert @actions.any? { |action| action.name == expected }, "Action #{expected.to_s} not found"
      end
    end
  
end