
class SlotsUseCase

  def initialize(repository)
    @repository = repository
  end

  def availableSlots
    slotList = @repository.getSlotList
    slotList.availableSlots
  end

  def addCar(carName)
    slotList = @repository.getSlotList
    slot = slotList.bookSlot(carName)
    @repository.saveSlotList(slotList)
    slot
  end

  def getCarIn(slot)
    slotList = @repository.getSlotList
    carName = slotList.getCarIn(slot)
    carName
  end


  def removeCar(carName)
    slotList = @repository.getSlotList
    # not sure if we should have this getslot-emptyslot in here or if we should have one single removeCar function in the domain layer
    slot = slotList.slotOfCar(carName)
    bookingDuration = slotList.emptySlot(slot)
    @repository.saveSlotList(slotList)
    bookingDuration
  end
end
