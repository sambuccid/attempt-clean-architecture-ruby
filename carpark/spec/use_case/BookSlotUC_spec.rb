require 'rspec'
require 'carpark/domain/exceptions/DuplicateCar'
require 'carpark/use_case/BookSlotUC'
require 'carpark/domain/SlotList'

describe BookSlotUC do

  class MockedSetting
    def max_slots
      12
    end
  end
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
    slotList = SlotList.new(MockedSetting.new.max_slots)
    useCase = makeUseCase(slotList)
    useCase.do('macchina')

    slotsAvailable = slotList.emptySlots
    expect(slotsAvailable).to eq(MockedSetting.new.max_slots - 1)
  end

  it "shouldn't be possible to book a slot with the same carName" do
    carName = 'car'
    slotList = SlotList.new(MockedSetting.new.max_slots)
    useCase = makeUseCase(slotList)

    useCase.do(carName)
    expect {
      useCase.do(carName)
    }.to raise_error(DuplicateCar)
  end

  it "should be possible to book a slot with a car that was previously booked but then left" do
    carName = 'car'
    slotList = SlotList.new(MockedSetting.new.max_slots)
    useCase = makeUseCase(slotList)
    
    slot = useCase.do(carName)

    slotList.emptySlot(slot)

    slot = useCase.do(carName)
  end
end
