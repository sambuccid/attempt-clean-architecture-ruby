class CheckOutUC
    def initialize(repository)
      @repository = repository
    end
  
    def do(carName)
      slotList = @repository.getSlotList
      slot = slotList.slotOfCar(carName)
      timeBooked = slotList.emptySlot(slot)
      bookingDurationSeconds = Time.now - timeBooked
      bookingDurationMinutes = (bookingDurationSeconds / 60).ceil
      
      @repository.saveSlotList(slotList)
      bookingDurationMinutes
    end
  end
  