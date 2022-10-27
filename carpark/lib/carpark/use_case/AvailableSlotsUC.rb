class AvailableSlotsUC

  def initialize(repository)
    @repository = repository
  end
  
  def do
    slotList = @repository.getSlotList
    slotList.emptySlots
  end
end
