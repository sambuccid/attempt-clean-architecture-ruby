require './layers/interface-adapters/entity/SlotList'

class MemoryRepository

  def initialize(settings)
    @memory = {
      slots: nil
    }

    emptySlotList = SlotList.new(settings)
    saveSlotList(emptySlotList)
    @settings = settings
  end

  def getSlotList
    SlotList.new(@settings, @memory[:slots])
  end

  def saveSlotList(slotList)
    slotArray = slotList.getAllSlotsAsArray
    @memory[:slots] = Marshal.load( Marshal.dump(slotArray) ) #A bit a hack, but for an in memory DB should be fine, closest to what a DB would actually do
  end
end
