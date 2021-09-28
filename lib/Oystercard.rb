class Oystercard
  attr_accessor :balance , :in_use , :entry_station , :exit_station , :journeys_array

  MINIMUM = 1
  LIMIT = 90

  def initialize
    @balance = 0
    @in_use = false
    @entry_station = nil
    @exit_station = nil
    @journey_hash = {}
    @journeys_array = []
  end

  def top_up(num)
    raise "Card limit exceeded (£#{LIMIT})" if num + self.balance > LIMIT
    @balance += num
  end

  def touch_in(station)
    raise "Insufficient funds - please top up" if self.balance < MINIMUM
    @in_use = true
    @entry_station = station
    @journey_hash.clear()
    @journey_hash[:entry] = @entry_station
  end

  def touch_out(station)
    @in_use = false
    self.deduct(1)
    @exit_station = station
    @journey_hash[:exit] = @exit_station
    @journeys_array << @journey_hash
  end

  def in_journey?
    @entry_station == nil ? false : true
  end

  private
  def deduct(amount)
    self.balance -= amount  
  end
end