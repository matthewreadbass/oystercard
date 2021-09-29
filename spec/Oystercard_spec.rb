require "oystercard"

describe Oystercard do
  let(:card) { Oystercard.new }
  let(:card_minimum) { Oystercard::CARD_MINIMUM }
  let(:card_limit) { Oystercard::CARD_LIMIT }
  let(:minimum_fare) { Oystercard::MINIMUM_FARE }
  let(:entry_station_double) { instance_double Oystercard, entry_station: "Kent House" }
  let(:exit_station_double) { instance_double Oystercard, exit_station: "Victoria" }

  it "has a default value of 0" do
    expect(subject.balance).to eq 0
  end

  before do
    card.top_up(10)
    card.touch_in(entry_station_double)
  end

  it "adds money" do
    expect { card.top_up(10) }.to change { card.balance }.to 20
  end

  it "throws exception when balance > 90" do
    expect { card.top_up(100) }.to raise_error "Card limit exceeded (£90)"
  end

  it "deducts fare" do
    expect { card.send(:deduct, 1) }.to change { card.balance }.to 9
  end

  it "returns true when customer touches in" do
    card.balance = card_minimum
    expect(card.in_journey?).to be_truthy
  end

  it "returns false when customer touches out" do
    card.touch_out(exit_station_double)
    expect(card.in_journey?).to be_falsy
  end

  it "returns true when card.in_journey?" do
    card.balance = card_minimum
    expect(card.in_journey?).to be_truthy
  end

  it "returns false when card not .in_journey?" do
    card.touch_out(exit_station_double)
    expect(card.in_journey?).to be_falsy
  end

  it "raises an error if the balance is less than £1 when touching in" do
    card.balance = 0
    expect { card.touch_in(entry_station_double) }.to raise_error "Insufficient funds - please top up"
  end

  it "deducts money for completed journey" do
    expect { card.touch_out(exit_station_double) }.to change { card.balance }.by(-minimum_fare)
  end

  it "returns entry station" do
    expect(card.entry_station).to eq entry_station_double
  end

  it "returns exit station" do
    card.touch_out(exit_station_double)
    expect(card.exit_station).to eq exit_station_double
  end

  it "has an empty @journeys_array by default" do
    expect(card.journeys_array).to eq []
  end

  it "creates one jouney after touch_in & touch_out" do
    card.touch_out(exit_station_double)
    expect(card.journeys_array.length).to eq 1
  end

  it "raises an error if card is already in_journey?" do
    expect { card.touch_in(entry_station_double) }.to raise_error "Oystercard already in journey - please touch out"
  end

  it "raises an error if card.touch_out is not currently in_journey?" do
    card.touch_out(exit_station_double)
    expect { card.touch_out(exit_station_double) }.to raise_error "Oystercard not currently in journey - please touch in"
  end
end
