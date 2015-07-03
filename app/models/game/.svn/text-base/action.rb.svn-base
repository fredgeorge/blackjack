# Understands something that can be done at a particular stage of the game
class Action
  include Comparable
  attr_reader :message, :name
  
  def self.hit_me(hand)
    Action.new(:hit_me, "[H]it me!") { hand.hit_me! }
  end
  
  def self.stand(hand)
    Action.new(:stand, "[S]tand") { hand.stand! }
  end
  
  def self.split(hand)
    Action.new(:split, "S[p]lit") { hand.split! }
  end
  
  def self.double_down(hand)
    Action.new(:double_down, "[D]ouble down") { hand.double_down! }
  end
  
  def self.quit
    Action.new(:quit, "[Q]uit") { raise GameComplete.new }
  end
  
  def self.number_of_players(game)
    Action.new(:number_of_players, '[N]umber of players ## (1-8)') { |n| game.player_count(n) }
  end
  
  def self.start_betting(game)
    Action.new(:start_betting, '[S]tart betting') { game.start_betting }
  end
  
  def self.bet(game)
    Action.new(:bet, '[B]et ## (between 1 to all your money)') { |n| game.bet(n) }
  end
  
  def self.deal(game)
    Action.new(:deal, '[D]eal') { game.deal }
  end
  
  def self.payout(game)
    Action.new(:payout, '[P]ayout') { game.payout }
  end
  
  def self.play(game, action)  # Action decorator
    Action.new(('play_' + action.name.to_s).to_sym, action.message) { |n| game.play(action, n) }
  end
  
  def initialize(name, message, &block)
    @name = name
    @message = message
    @block = block
  end
  
  def execute(*parms)
    @block.call(*parms)
  end
  
  def <=>(other)
    name.to_s <=> other.name.to_s
  end
  
  def self.letter_map(actions)
    results = {}
    actions.each do |action| 
      action.message =~ /\[(\w)\]/
      results[$1.upcase] = action
    end
    results
  end
  
end