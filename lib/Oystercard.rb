class Oystercard
  attr_accessor :balance , :in_use

  LIMIT = 90

  def initialize
    @balance = 0
    @in_use = false
  end

  def top_up(num)
    raise "Card limit exceeded (£#{LIMIT})" if num + self.balance > LIMIT
    @balance += num
  end
  
  def deduct(num)
    @balance -= num
  end

  def touch_in
    @in_use = true
  end

  def touch_out
    @in_use = false
  end

  def in_journey?
    @in_use
  end
  
end