class GetCarInSlotUC
  def initialize(repository)
    @repository = repository
  end
  
  def do(slot)
    slotList = @repository.getSlotList
    carName = slotList.getCarIn(slot)
    carName
  end
end
  