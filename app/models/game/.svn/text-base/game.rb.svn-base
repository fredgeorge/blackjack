# Understands the play of rounds of Blackjack
class Game  
  attr_reader :dealer_hand, :players
  
  def initialize(*starting_cards)
    @current_player_index = 0
    @players = create_players(6)
    @shoe = Shoe.new *starting_cards
  end
  
  def current_player
    @players[@current_player_index]
  end

  # Action handlers
  
  def start
    [['', '', "Welcome to Console Blackjack.", 
      "Currently, there is a Dealer and #{number_of_players} Player(s)."], 
      start_actions]
  end
  
  def number_of_players
    @players.length
  end
  
  def player_count(count)
    if count.nil? || count.to_i < 1 || count.to_i > 8
      return [["Player count must be between 1 and 8."], start_actions]
    end
    @players = create_players(count.to_i)
    [["Now there is a Dealer and #{number_of_players} Player(s)."], start_actions]
  end
  
  def start_betting
    return start_dealing unless current_player
    [["#{current_player.to_s}:  Place your bet! ($1 to $#{current_player.money})"], bet_actions]
  end
  
  def bet(amount)
    messages = current_player.betting(amount)
    return [messages, bet_actions] if messages
    next_player
    start_betting
  end
  
  def start_dealing
    [["all bets have been placed.  Ready to deal."],
    [Action.quit, Action.deal(self)].sort!]
  end
  
  def deal
    @current_player_index = 0
    messages = @players.inject(['']) do |messages, player| 
      player.dealt @shoe.new_player_hand 
      messages << player.describe_hand
    end
    @dealer_hand = @shoe.new_dealer_hand
    messages << "Dealer has two cards with #{@dealer_hand.describe}"
    messages << play_messages
    play_hand messages, current_player.actions  # start recursion
  end
  
  def play(action, parameter)
    play_hand *current_player.play(action, parameter)  # start recursion
  end
  
  def payout
    messages = resolve_bets
    messages = kick_out_broke_players messages
    return restart(messages) if @players.empty?
    continue_play messages
  end
  
  def restart(messages)
    player_count(6)
    messages << "New table!  There is a Dealer and #{number_of_players} Player(s)." 
    [messages, start_actions]
  end

  private
  
    def dealer_plays(messages)
      messages << ''
      messages << 'Dealer playing...'
      (messages << @dealer_hand.play).flatten!
      messages << ''
      messages << 'Ready to resolve bets'
      [messages, [Action.quit, Action.payout(self)]]
    end
  
    def create_players(count)
      @players = (1..count).to_a.collect { |i| Player.new("Player #{i}") }
    end
    
    def start_actions
      [Action.quit, Action.number_of_players(self), Action.start_betting(self)].sort!
    end
    
    def bet_actions
      [Action.quit, Action.bet(self)].sort!
    end
    
    def play_actions
      results = [Action.quit]
      player_actions = current_player.actions
      unless current_player.double_down?
        player_actions = player_actions.reject { |a| a.name == :double_down }
      end
      unless current_player.split?
        player_actions = player_actions.reject { |a| a.name == :split }
      end
      player_actions.each { |a| results << Action.play(self, a) }
      results.sort
    end
    
    def play_messages
      ['', "#{current_player.to_s}'s turn...", "#{current_player.describe_hand}"]
    end
    
    def current_hand
      current_player.hand
    end

    def next_hand
      next_player unless current_player.next_hand
    end
    
    def next_player
      @current_player_index += 1
    end
    
    def resolve_bets
      messages = []
      all_hands_with_bets.each do |player, hand, bet|
        winnings = (hand.payout(@dealer_hand) * bet).round   # stay with integers, even if dealer loses 50 cents
        player.won winnings + bet 
        messages << "#{player.to_s} had #{hand.describe} and loses bet of $#{bet}." if winnings < 0
        messages << "#{player.to_s} had #{hand.describe} and ties.  Bet of $#{bet} returned." if winnings == 0
        messages << "#{player.to_s} had #{hand.describe} and wins $#{winnings}!" if winnings > 0
        messages << "#{player.to_s} now has $#{player.money} after resolving this bet"
        messages << ''
      end
      messages
    end
    
    def all_hands_with_bets
      results = []
      @players.each do |player|
        player.hands.zip(player.bets).each { |hand, bet| results << [player, hand, bet] }
      end
      results
    end
    
    def kick_out_broke_players(messages)
      @players.delete_if do |player| 
        messages << "#{player.to_s} is out of money and out of the game!" if player.money <= 0
        player.money <= 0
      end
      messages
    end
    
    def continue_play(messages)
      messages << "Currently, there is a Dealer and #{number_of_players} Player(s)."
      @current_player_index = 0
      [messages, [Action.quit, Action.start_betting(self)].sort!]
    end
    
    def play_hand(messages, actions)
      if actions.empty?  # this player is done
        next_hand
        return dealer_plays(messages) unless current_player  # terminal condition: no more players
        messages << play_messages
        return play_hand messages, current_player.actions  # recurse
      end
      messages << ''    # terminal condition: need input from player
      messages << current_player.describe_hand
      [messages, play_actions]
    end
    
end