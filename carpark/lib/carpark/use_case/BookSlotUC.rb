class BookSlotUC

  def initialize(repository)
    @repository = repository
  end
  
  def do(carName)
    slotList = @repository.getSlotList
    
    if carNameAlreadyBooked?(slotList, carName)
      raise DuplicateCar
    end
    
    slot = slotList.bookSlot(carName)
    @repository.saveSlotList(slotList)
    slot
  end

  private

  def carNameAlreadyBooked?(slotList, carName)
    allSlots = slotList.getAllSlots
    bookedSlots = allSlots.select {|slot| !slot.nil? }
    bookedSlots.any? {|slot| slot.carName == carName}
  end

end
  