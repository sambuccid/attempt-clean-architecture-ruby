require 'rspec'
require 'carpark/domain/SlotList'

describe SlotList do
  MAX_SLOTS = 12
  
  def build_init_array_slots(length, *values)
    slots = Array.new(length)
    slots.fill(SlotList::EMPTY_VALUE)
    values.each_with_index do |value, idx|
      slots[idx] = value
    end

    slots
  end

  context "create new slotlist object" do
    it "creates an object with correct amount of slots" do
      slotList = SlotList.new(MAX_SLOTS)
      length = slotList.getAllSlotsAsArray.length()
      expect(length).to eq(MAX_SLOTS)
    end

    it "loads data of slots" do
      slots_from_repository = build_init_array_slots(MAX_SLOTS,
                                               Slot.new("1", Time.now),
                                               Slot.new("2", Time.now))

      slotList = SlotList.new(MAX_SLOTS, slots_from_repository)
      slotsAvailable = slotList.emptySlots
      expect(slotsAvailable).to eq(MAX_SLOTS - 2)
    end
  end
end
