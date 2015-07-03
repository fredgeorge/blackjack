require "test/unit"
%w[shoe hand card].each { |file| require File.dirname(__FILE__) + "/../../app/models/cards/#{file}" }
%w[game action game_complete player].each { |file| require File.dirname(__FILE__) + "/../../app/models/game/#{file}" }

# Ensures that bets can be made at the appropriate stage of a Game
class GameInitialBetsTest < Test::Unit::TestCase
  
  def test_betting_player_can_quit
    game = create_game(1)
    assert_action :quit
    assert_action :bet
    assert_raise(GameComplete) { action(:quit).execute }
  end
  
  def test_1_player_can_bet
    game = create_game(1)
    player = game.current_player
    messages, @actions = action(:bet).execute(15)
    assert 1000 - 15, player.money
    assert 15, player.bet
    assert_action :quit
    assert_action :deal
    assert_raise(GameComplete) { action(:quit).execute }
    assert player != game.current_player
  end
  
  def test_invalid_bets_detected
    game = create_game(1)
    player = game.current_player
    [0, 1001, -1, 'none'].each do |amount|
      messages, @actions = action(:bet).execute(amount)
      assert_action :bet
      assert_action :quit
      assert messages[0].include?('between'), messages[0]
    end
    messages, @actions = action(:bet).execute(15)
    assert_action :deal
    assert_raise(GameComplete) { action(:quit).execute }
  end
  
  def test_multiple_players_betting
    game = create_game(3)
    [10, 15, 20].each do |bet|
      player = game.current_player
      messages, @actions = action(:bet).execute(bet)
      assert_equal 1000 - bet, player.money
    end
    assert_action :deal
    assert_raise(GameComplete) { action(:quit).execute }
  end
  
  private
  
    def create_game(number_of_players)
      result = Game.new
      messages, @actions = result.start
      messages, @actions = action(:number_of_players).execute(number_of_players)
      messages, @actions = action(:start_betting).execute
      result
    end
    
    def action(name)
      @actions.find { |a| a.name == name}
    end
    
    def assert_action(name)
      assert !action(name).nil?, "Can't find action for '#{name.to_s}'"
    end
    
end