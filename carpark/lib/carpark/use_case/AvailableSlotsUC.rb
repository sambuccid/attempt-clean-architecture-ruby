class AvailableSlotsUC

  def initialize(repository)
    @repository = repository
  end
  
  def do
    slotList = @repository.getSlotList
    slotList.availableSlots
  end
end
