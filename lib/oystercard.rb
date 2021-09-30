class Oystercard
  attr_accessor :balance, :in_use, :entry_station, :exit_station, :journeys_array

  CARD_MINIMUM = 1
  CARD_LIMIT = 90
  MINIMUM_FARE = 1

  def initialize
    @balance = 0
    @entry_station = nil
    @exit_station = nil
    @journey_hash = {}
    @journeys_array = []
  end

  def top_up(num)
    raise "Card limit exceeded (£#{CARD_LIMIT})" if num + self.balance > CARD_LIMIT
    @balance += num
  end

  def touch_in(station)
    raise "Insufficient funds - please top up" if self.balance < CARD_MINIMUM
    raise "Oystercard already in journey - please touch out" if self.in_journey? == true
    @entry_station = station
    @exit_station = nil
    @journey_hash.clear()
    @journey_hash[:entry] = @entry_station
  end

  def touch_out(station)
    raise "Oystercard not currently in journey - please touch in" if self.in_journey? == false
    self.deduct(MINIMUM_FARE)
    @exit_station = station
    @entry_station = nil
    @journey_hash[:exit] = @exit_station
    @journeys_array << @journey_hash
  end

  def in_journey?
    !!@entry_station
  end

  private

  def deduct(amount)
    @balance -= amount
  end
end
