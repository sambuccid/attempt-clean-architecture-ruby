require 'rspec'
require 'carpark/domain/exceptions/DuplicateCar'
require 'carpark/domain/SlotList'

describe SlotList do

  class MockedSetting
    def max_slots
      12
    end
  end

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
      slotList = SlotList.new(MockedSetting.new)
      length = slotList.getAllSlotsAsArray.length()
      expect(length).to eq(MockedSetting.new.max_slots)
    end

    it "loads data of slots" do
      # slots_from_repository = Array.new(MockedSetting.new.max_slots)
      # slots_from_repository.fill(SlotsHolder::EMPTY_VALUE)
      #
      # #2 slots were already used
      # slots_from_repository[0] = Slot.new("1", DateTime.now)
      # slots_from_repository[1] = Slot.new("2", DateTime.now)

      slots_from_repository = build_init_array_slots(MockedSetting.new.max_slots,
                                               Slot.new("1", Time.now),
                                               Slot.new("2", Time.now))

      slotList = SlotList.new(MockedSetting.new, slots_from_repository)
      slotsAvailable = slotList.emptySlots
      expect(slotsAvailable).to eq(MockedSetting.new.max_slots - 2)
    end
  end
end
