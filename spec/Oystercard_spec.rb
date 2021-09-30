require "oystercard"

describe Oystercard do
  let(:card) { Oystercard.new }
  let(:entry_station_double) { instance_double Oystercard, entry_station: "Kent House" }
  let(:exit_station_double) { instance_double Oystercard, exit_station: "Victoria" }

  before do
    card.top_up(10)
    card.touch_in(entry_station_double)
  end

  describe "initialize" do
    it "has a default value of 0" do
      expect(subject.balance).to eq 0
    end
  end

  describe ".top_up" do
    it "adds money" do
      expect { subject.top_up(10) }.to change { subject.balance }.to 10
    end

    it "throws exception when balance > 90" do
      expect { card.top_up(100) }.to raise_error "Card limit exceeded (£90)"
    end
  end

  describe "deduct" do
    it "deducts fare" do
      expect { card.send(:deduct, 1) }.to change { card.balance }.to 9
    end
  end

  describe "touch_in" do
    it "returns true when customer touches in" do
      card.balance = Oystercard::CARD_MINIMUM
      expect(card.in_journey?).to be_truthy
    end

    it "raises an error if the balance is less than £1 when touching in" do
      card.balance = 0
      expect { card.touch_in(entry_station_double) }.to raise_error "Insufficient funds - please top up"
    end

    it "raises an error if card is already in_journey?" do
      expect { card.touch_in(entry_station_double) }.to raise_error "Oystercard already in journey - please touch out"
    end
  end

  describe "touch_out" do
    it "returns false when customer touches out" do
      card.touch_out(exit_station_double)
      expect(card.in_journey?).to be_falsy
    end

    it "deducts money for completed journey" do
      expect { card.touch_out(exit_station_double) }.to change { card.balance }.by(-Oystercard::MINIMUM_FARE)
    end

    it "raises an error if card.touch_out is not currently in_journey?" do
      card.touch_out(exit_station_double)
      expect { card.touch_out(exit_station_double) }.to raise_error "Oystercard not currently in journey - please touch in"
    end
  end

  describe "in_journey?" do
    it "returns true when card.in_journey?" do
      card.balance = Oystercard::CARD_MINIMUM
      expect(card.in_journey?).to be_truthy
    end

    it "returns false when card not .in_journey?" do
      card.touch_out(exit_station_double)
      expect(card.in_journey?).to be_falsy
    end
  end

  describe "entry_station" do
    it "returns entry station" do
      expect(card.entry_station).to eq entry_station_double
    end
  end

  describe "exit_station" do
    it "returns exit station" do
      card.touch_out(exit_station_double)
      expect(card.exit_station).to eq exit_station_double
    end
  end

  describe "journeys_array" do
    it "has an empty @journeys_array by default" do
      expect(card.journeys_array).to eq []
    end

    it "creates one jouney after touch_in & touch_out" do
      card.touch_out(exit_station_double)
      expect(card.journeys_array.length).to eq 1
    end
  end
end
