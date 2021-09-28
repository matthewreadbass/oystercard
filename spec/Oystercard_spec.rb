require "oystercard"

describe Oystercard do
  let (:card) { Oystercard.new }

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
    expect { card.deduct(10) }.to change { card.balance }.to 70
  end

  it "returns true when customer touches in" do
    card.touch_in
    expect(card.in_use).to be_truthy
  end

  it "returns false when customer touches out" do
    card.touch_out
    expect(card.in_use).to be_falsy
  end

  it "returns true when card.in_journey?" do
    card.touch_in
    expect(card.in_journey?).to be_truthy
  end

  it "returns false when card not .in_journey?" do
    card.touch_out
    expect(card.in_journey?).to be_falsy
  end

end