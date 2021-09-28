class Oystercard
  attr_accessor :balance , :in_use , :entry_station

  MINIMUM = 1
  LIMIT = 90

  def initialize
    @balance = 0
    @in_use = false
    @entry_station = nil
  end

  def top_up(num)
    raise "Card limit exceeded (£#{LIMIT})" if num + self.balance > LIMIT
    @balance += num
  end

  def touch_in(station)
    raise "Insufficient funds - please top up" if self.balance < MINIMUM
    @in_use = true
    @entry_station = station
  end

  def touch_out
    @in_use = false
    self.deduct(1)
  end

  def in_journey?
    @entry_station == nil ? false : true
  end

  private
  def deduct(amount)
    self.balance -= amount  
  end
end