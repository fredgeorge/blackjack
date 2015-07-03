require "test/unit"
%w[shoe hand card dealer_hand].each { |file| require File.dirname(__FILE__) + "/../../app/models/cards/#{file}" }
%w[game action game_complete player].each { |file| require File.dirname(__FILE__) + "/../../app/models/game/#{file}" }

# Ensures that Hands can be dealt during the Game
class GameDealingTest < Test::Unit::TestCase
  
  def test_dealing_to_one_player_and_dealer
    game = create_game(3)
    assert_actions :quit, :deal
    messages, @actions = action(:deal).execute
    assert_equal 8, messages.length, messages.to_s
    assert_raise(GameComplete) { action(:quit).execute }
  end
  
  private
  
    def create_game(number_of_players)
      result = Game.new
      messages, @actions = result.start
      messages, @actions = action(:number_of_players).execute(number_of_players)
      messages, @actions = action(:start_betting).execute
      number_of_players.times { messages, @actions = action(:bet).execute(25) }
      result
    end

    def action(name)
      @actions.find { |a| a.name == name}
    end

    def assert_actions(*names)
      names.each { |name| assert !action(name).nil?, "Can't find action for '#{name.to_s}'" }
    end
    
end