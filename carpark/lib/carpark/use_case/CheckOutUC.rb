class CheckOutUC
    def initialize(repository)
      @repository = repository
    end
  
    def do(carName)
      slotList = @repository.getSlotList
      slotNumber = slotList.slotOfCar(carName)
      slot = slotList.emptySlot(slotNumber)

      duration = Time.now - slot.timeBooked
      @repository.saveSlotList(slotList)
      convertToMinutes(duration)
    end

    private
    def convertToMinutes(time)
      (time / 60).ceil
    end
  end
  