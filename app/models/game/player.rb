# Understands a sucker who thinks they can beat the house
class Player
  attr_reader :money, :hands, :bets
  
  def initialize(name)
    @name = name
    @money = 1000
  end
  
  def betting(amount)
    return ["Please specify a bet between $1 and $#{@money}"] unless amount && amount.to_i > 0 && amount.to_i <= @money
    amount = amount.to_i
    @bets = [amount]
    @money -= amount
    @current_hand_index = 0
    nil
  end
  
  def won(amount)
    @money += amount
  end
  
  def dealt(hand)
    @hands = [hand]
    @current_hand_index = 0
  end  
    
  def describe_hand
    hand_description = @hands.length == 1 ? '' : ", Hand #{@current_hand_index + 1}"
    "#{@name}#{hand_description} holds #{hand.describe}"
  end
  
  def actions
    hand.actions
  end
  
  def play(action, parameter)
    if action.name == :double_down
      @money -= bet
      @bets[@current_hand_index] *= 2
    end
    messages, actions = action.execute(parameter)
    if action.name == :split
      @money -= bet
      @bets << bet
      @hands << hand.split_hand
    end
    [messages, actions]
  end
  
  def double_down?
    money >= bet && hand.double_down?
  end
  
  def split?
    money >= bet && hand.split?
  end
  
  def hand
    @hands[@current_hand_index]
  end
  
  def bet
    @bets[@current_hand_index] || @bets.last
  end
  
  def next_hand
    @current_hand_index += 1
    hand
  end
  
  def to_s
    @name
  end
  
end