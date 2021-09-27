require "oystercard"

describe Oystercard do

  it "has a default value of 0" do
    expect(subject.balance).to eq 0
  end

  it "adds money" do
    expect { subject.top_up(10) }.to change { subject.balance }.to 10
  end

  it "throws exception when balance > 90" do
    expect { subject.top_up(100) }.to raise_error "Card limit exceeded (£90)"
  end

end