require "test/unit"
%w[shoe hand card dealer_hand].each { |file| require File.dirname(__FILE__) + "/../../app/models/cards/#{file}" }
%w[game action game_complete player].each { |file| require File.dirname(__FILE__) + "/../../app/models/game/#{file}" }

# Ensures that Hands can be played through the Game
class GamePlayingTest < Test::Unit::TestCase
  
  def test_playing_with_one_player_and_dealer
    game = create_game(1)
    assert_actions :quit, :play_hit_me, :play_stand, :play_double_down
    choose :play_hit_me
    assert_raise(GameComplete) { action(:quit).execute }
  end
  
  def test_playing_with_multiple_players
    game = create_game(3)
    choose :play_hit_me
    choose :play_stand
    choose :play_stand
    messages, ignore = choose :play_stand
    assert messages[2].include?('ealer playing'), messages.inspect
    assert_raise(GameComplete) { action(:quit).execute }
  end
  
  def test_bet_doubling_on_double_down
    game = create_game(1)
    player1 = game.current_player
    assert_equal 25, player1.bet
    messages, actions = choose :play_double_down
    assert_equal 50, player1.bet
    assert_actions :quit, :payout
    assert_raise(GameComplete) { action(:quit).execute }
  end
  
  def test_bet_effect_on_splitting
    game = create_game(1)
    player1 = game.current_player
    assert_equal 1000 - 25, player1.money
    choose :play_split
    assert_equal 1000 - 25 - 25, player1.money
    assert_actions :quit, :play_hit_me, :play_double_down, :play_stand
    assert_raise(GameComplete) { action(:quit).execute }
  end
  
  def test_playing_a_split_safely
    game = create_game(2)
    player1 = game.current_player
    choose :play_split
    assert_equal 6, player1.hand.high_value
    choose :play_stand
    assert_equal 7, player1.hand.high_value
    choose :play_stand
    player2 = game.current_player
    assert_equal 9, player2.hand.high_value
    choose :play_stand
    messages, actions = choose :payout
    assert 1000 - 25 - 25, player1.money   # lost both hands
    assert 1000, player2.money   # lost to dealer
    assert_raise(GameComplete) { action(:quit).execute }
  end
  
  private
  
    def create_game(number_of_players)
      result = Game.new :two, :two, :four, :five, :two, :three, :four, :five, :two, :three, :four, :five, :king, :king
      messages, @actions = result.start
      choose :number_of_players, number_of_players
      choose :start_betting
      number_of_players.times { choose :bet, 25 }
      choose :deal
      result
    end
    
    def choose(action_name, value = nil)
      messages, @actions = action(action_name).execute value
      [messages, @actions]
    end

    def action(name)
      @actions.find { |a| a.name == name}
    end

    def assert_actions(*names)
      names.each { |name| assert !action(name).nil?, "Can't find action for '#{name.to_s}'\nAll actions #{@actions.inspect}" }
    end
    
end