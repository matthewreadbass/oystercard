class Oystercard
  attr_accessor :balance

  LIMIT = 90
  
  def initialize
    @balance = 0
  end

  def top_up(num)
    raise "Card limit exceeded (£#{LIMIT})" if num + self.balance > LIMIT
    @balance += num
  end

end