require "oystercard"

describe Oystercard do
  let(:card) { Oystercard.new }
  let(:entry_station) { instance_double Oystercard, entry_station: "Kent House" }

  it "has a default value of 0" do
    expect(card.balance).to eq 0
  end

  it "adds money" do
    expect { card.top_up(10) }.to change { card.balance }.to 10
  end

  it "throws exception when balance > 90" do
    expect { card.top_up(100) }.to raise_error "Card limit exceeded (£90)"
  end

  it "deducts fare" do
    card.top_up(80)
    expect { card.send(:deduct, 10) }.to change { card.balance }.to 70
  end

  it "returns true when customer touches in" do
    card.balance = Oystercard::MINIMUM
    card.touch_in(:entry_station)
    expect(card.in_use).to be_truthy
  end

  it "returns false when customer touches out" do
    card.touch_out
    expect(card.in_use).to be_falsy
  end

  it "returns true when card.in_journey?" do
    card.balance = Oystercard::MINIMUM
    card.touch_in(:entry_station)
    expect(card.in_journey?).to be_truthy
  end

  it "returns false when card not .in_journey?" do
    card.touch_out
    expect(card.in_journey?).to be_falsy
  end

  it "raises an error if the balance is less than £1 when touching in" do
    card.balance = 0
    expect { card.touch_in(:entry_station) }.to raise_error "Insufficient funds - please top up"
  end

  it "deducts money for completed journey" do
    subject.balance = 5
    expect { subject.touch_out }.to change { subject.balance }.by(-1)
  end

  it "returns touch in station" do
    card.balance = 10
    card.touch_in(:entry_station)
    expect(card.entry_station).to eq :entry_station
  end

end