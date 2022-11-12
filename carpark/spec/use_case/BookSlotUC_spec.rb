require 'rspec'
require 'carpark/use_case/exceptions/DuplicateCar'
require 'carpark/use_case/BookSlotUC'
require 'carpark/domain/SlotList'

describe BookSlotUC do
  MAX_SLOTS = 12

  class MockedRepository
    def initialize(slotList)
      @slotList = slotList
    end
    def getSlotList
      @slotList
    end
    def saveSlotList(_slotList)
    end
  end

  def makeUseCase(slotList)
    repository = MockedRepository.new(slotList)
    BookSlotUC.new(repository)
  end

  it "we have less slot available when we book a slot" do
    slotList = SlotList.new(MAX_SLOTS)
    useCase = makeUseCase(slotList)
    useCase.do('car')

    slotsAvailable = slotList.emptySlots
    expect(slotsAvailable).to eq(MAX_SLOTS - 1)
  end

  it "shouldn't be possible to book a slot a car that has already booked in" do
    carName = 'car'
    slotList = SlotList.new(MAX_SLOTS)
    useCase = makeUseCase(slotList)

    useCase.do(carName)
    expect {
      useCase.do(carName)
    }.to raise_error(DuplicateCar)
  end

  it "should be possible to book a slot with a car that was previously booked but then left" do
    carName = 'car'
    slotList = SlotList.new(MAX_SLOTS)
    useCase = makeUseCase(slotList)
    
    slot = useCase.do(carName)

    slotList.emptySlot(slot)

    slot = useCase.do(carName)
  end
end
