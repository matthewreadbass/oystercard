require 'Oystercard'

describe Oystercard do
  
  it "responds to. tap_in" do
    expect(subject).to respond_to(:tap_in)
  end

end