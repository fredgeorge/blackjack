require "test/unit"
%w[shoe hand card dealer_hand].each { |file| require File.dirname(__FILE__) + "/../../app/models/cards/#{file}" }
%w[game action game_complete player].each { |file| require File.dirname(__FILE__) + "/../../app/models/game/#{file}" }

# Ensures that the appropriate payouts are made
class GamePayoutTest < Test::Unit::TestCase
  
  def test_payout_with_no_busts
    game = create_game_with_two_players 25, :two, :three, :king, :king, :queen, :seven
    assert_equal 5, game.current_player.hand.high_value
    stand
    assert_equal 20, game.current_player.hand.high_value
    stand
    assert_equal 17, game.dealer_hand.high_value
    messages, @actions = action(:payout).execute
    assert_equal 1000 - 25, game.players[0].money
    assert_equal 1000 + 25, game.players[1].money
    assert_raise(GameComplete) { action(:quit).execute }
  end
  
  def test_payout_with_blackjack
    game = create_game_with_two_players 500, :ace, :jack, :nine, :ten, :seven, :jack
    assert_equal 19, game.current_player.hand.high_value
    stand
    messages, @actions = action(:payout).execute
    assert_equal 1000 + 750, game.players[0].money
    assert_equal 1000 + 500, game.players[1].money
    assert_raise(GameComplete) { action(:quit).execute }
  end
  
  def test_payout_with_all_blackjacks_including_split
    game = create_game_with_two_players 500, :ace, :jack, :ace, :ace, :ten, :seven, :jack, :jack
    messages, @actions = action(:play_split).execute
    ignore, @actions = action(:payout).execute
    assert_equal 1000 + 750, game.players[0].money
    assert_equal 1000 + 750 + 750, game.players[1].money
    assert_raise(GameComplete) { action(:quit).execute }
  end
  
  def test_game_restart_when_all_players_out_of_money
    game = create_game_with_two_players 1000, :two, :three, :four, :five, :jack, :ace
    stand
    stand
    messages, @actions = action(:payout).execute
    assert_actions :quit, :number_of_players, :start_betting
    assert_raise(GameComplete) { action(:quit).execute }
  end
  
  def test_payout_after_split_when_winning_both_hands
    game = create_game_with_two_players 500, :ace, :ace, :three, :four, :ten, :seven, :nine, :nine
    messages, @actions = action(:play_split).execute
    stand  # Player 1, hand 1
    stand  # Player 1, hand 2
    stand  # Player 2 (only hand)
    messages, @actions = action(:payout).execute
    assert_equal 1000 + 500 + 500, game.players[0].money
    assert_equal 1000 - 500, game.players[1].money
    assert_raise(GameComplete) { action(:quit).execute }
  end
  
  def test_payout_after_split_busting_first_hand
    game = create_game_with_two_players 500, :ten, :ten, :three, :four, :ten, :seven, :nine, :nine, :ten
    messages, @actions = action(:play_split).execute
    hit_me  # Player 1, hand 1
    stand  # Player 1, hand 2
    stand  # Player 2 (only hand)
    messages, @actions = action(:payout).execute
    assert_equal 1000 + 500 - 500, game.players[0].money
    assert_equal 1000 - 500, game.players[1].money
    assert_raise(GameComplete) { action(:quit).execute }
  end
  
  def test_payout_after_blackjact_first_hand
    game = create_game_with_two_players 500, :ten, :ten, :three, :four, :ten, :seven, :ace, :nine
    messages, @actions = action(:play_split).execute # blackjack; skipping more actions here
    stand  # Player 1, hand 2
    stand  # Player 2 (only hand)
    messages, @actions = action(:payout).execute
    assert_equal 1000 + 750 + 500, game.players[0].money
    assert_equal 1000 - 500, game.players[1].money
    assert_raise(GameComplete) { action(:quit).execute }
  end
  
  private
  
    def create_game_with_two_players(bet, *starting_cards)
      result = Game.new *starting_cards
      messages, @actions = result.start
      messages, @actions = action(:number_of_players).execute(2)
      messages, @actions = action(:start_betting).execute
      2.times { messages, @actions = action(:bet).execute(bet) }
      messages, @actions = action(:deal).execute
      result
    end
    
    def stand
    messages, @actions = action(:play_stand).execute
    [messages, @actions]
    end

    def hit_me
    messages, @actions = action(:play_hit_me).execute
    [messages, @actions]
    end

    def action(name)
      @actions.find { |a| a.name == name}
    end

    def assert_actions(*names)
      names.each { |name| assert !action(name).nil?, "Can't find action for '#{name.to_s}'\nAll actions #{@actions.inspect}" }
    end
    
end