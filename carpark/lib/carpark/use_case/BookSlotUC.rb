class BookSlotUC

  def initialize(repository)
    @repository = repository
  end
  
  def do(carName)
    slotList = @repository.getSlotList
    slot = slotList.bookSlot(carName)
    @repository.saveSlotList(slotList)
    slot
  end
end
  