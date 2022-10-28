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

  context "when we check out a slot" do
    it "we get the duration of how long the slot was booked for in minutes" do
      # Given we booked a slot
      slotList = SlotList.new(MockedSetting.new)
      slot = slotList.bookSlot('macchina')
      # When we check out the car
      time = slotList.emptySlot(slot)
      # We get back the duration of the slot in minutes
      expect(time).to be_a(Integer)
    end
    it "the duration we get back is correct" do
      # Given we booked a slot 13 minutes ago
      initSlots = build_init_array_slots(MockedSetting.new.max_slots,
                                         Slot.new("macchina", Time.now - 13*60))
      #
      slotList = SlotList.new(MockedSetting.new, initSlots)
      # When we check out the car
      time = slotList.emptySlot(0)
      # We get back the duration of the slot in minutes
      expect(time).to eq(13).or eq(14)
    end
  end
end
