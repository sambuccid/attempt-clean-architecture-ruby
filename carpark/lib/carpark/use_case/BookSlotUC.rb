require 'carpark/use_case/exceptions/ParkIsFull'
require 'carpark/use_case/exceptions/DuplicateCar'

class BookSlotUC

  def initialize(repository)
    @repository = repository
  end
  
  def do(carName)
    slotList = @repository.getSlotList
    
    if slotList.full?
      raise ParkIsFull
    end

    if carNameAlreadyBooked?(slotList, carName)
      raise DuplicateCar
    end

    slotNumber = slotList.getFirstEmptySlot
    
    slotList.setSlot(slotNumber, carName, Time.now)
    @repository.saveSlotList(slotList)
    slotNumber
  end

  private

  def carNameAlreadyBooked?(slotList, carName)
    allSlots = slotList.getAllSlots
    bookedSlots = allSlots.select {|slot| !slot.nil? }
    bookedSlots.any? {|slot| slot.carName == carName}
  end

end
  