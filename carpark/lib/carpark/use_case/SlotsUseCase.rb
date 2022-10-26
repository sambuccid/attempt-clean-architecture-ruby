class SlotsUseCase

  def initialize(repository)
    @repository = repository
  end

  def removeCar(carName)
    slotList = @repository.getSlotList
    slot = slotList.slotOfCar(carName)
    bookingDuration = slotList.emptySlot(slot)
    @repository.saveSlotList(slotList)
    bookingDuration
  end
end
