class Oystercard
  attr_accessor :balance
  
  def initialize
    @balance = 0
  end

  def top_up(num)
    @balance += num
  end

end