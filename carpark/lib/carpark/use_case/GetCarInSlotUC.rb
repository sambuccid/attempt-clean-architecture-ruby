class GetCarInSlotUC
  def initialize(repository)
    @repository = repository
  end
  
  def do(slot)
    slotList = @repository.getSlotList
    slot = slotList.getSlot(slot)
    slot&.carName
  end
end
  