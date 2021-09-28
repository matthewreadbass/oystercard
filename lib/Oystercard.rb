class Oystercard
  attr_accessor :balance , :in_use

  MINIMUM = 1
  LIMIT = 90

  def initialize
    @balance = 0
    @in_use = false
  end

  def top_up(num)
    raise "Card limit exceeded (£#{LIMIT})" if num + self.balance > LIMIT
    @balance += num
  end

  def touch_in
    raise "Insufficient funds - please top up" if self.balance < MINIMUM
    @in_use = true
  end

  def touch_out
    @in_use = false
    self.deduct(1)
  end

  def in_journey?
    @in_use
  end

  private
  def deduct(amount)
    self.balance -= amount  
  end
end