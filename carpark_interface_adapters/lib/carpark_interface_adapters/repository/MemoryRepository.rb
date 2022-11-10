require 'carpark/domain/SlotList'

class MemoryRepository
  def initialize(max_slots)
    @memory = {
      slots: nil
    }

    emptySlotList = SlotList.new(max_slots)
    saveSlotList(emptySlotList)
  end

  def getSlotList
    SlotList.new(@max_slots, @memory[:slots])
  end

  def saveSlotList(slotList)
    slotArray = slotList.getAllSlotsAsArray
    # A bit of a hack, but for an in memory DB should be fine, it is very close to what an actual Repository would do
    @memory[:slots] = Marshal.load( Marshal.dump(slotArray) )
    @max_slots = slotList.max_slots
  end
end
