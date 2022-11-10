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
    @memory[:slots] = Marshal.load( Marshal.dump(slotArray) ) #A bit a hack, but for an in memory DB should be fine, closest to what a DB would actually do
    @max_slots = slotList.max_slots
  end
end
