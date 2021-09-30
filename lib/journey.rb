class Journey
  attr_reader :entry_station, :list_of_journeys, :exit_station, :journey

  def initialize
    @entry_station = nil
    @list_of_journeys = []
    @journey = {}
  end

  def touch_in(station)
    fail "Insufficient funds, you need at least £#{MIN_LIMIT} to touch in" if @balance < MIN_LIMIT
    @entry_station = station
    journey["entry_station"] = @entry_station
  end

  def touch_out(exit_station)
    deduct(MIN_CHARGE)
    @entry_station = nil
    @exit_station = exit_station
    journey["exit_station"] = @exit_station
  end

  def in_journey?
    @entry_station != nil 
  end
end
