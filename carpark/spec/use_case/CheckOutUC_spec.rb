require 'rspec'
require 'carpark/use_case/CheckOutUC'

describe CheckOutUC do
  class MockedSetting
    def max_slots
      12
    end
  end

  context "check out a car" do
    def create_repository_returning(slotList)
      repository = double
      allow(repository).to receive(:getSlotList).and_return(slotList)
      allow(repository).to receive(:saveSlotList)
      repository
    end

    it "gives back how long the slot was occupied for" do
      # Given I booked a slot
      slotList = SlotList.new(MockedSetting.new)
      slotList.bookSlot("car1")

      repository = create_repository_returning(slotList)
      useCase = CheckOutUC.new(repository)

      # When I check out the car
      bookingDuration = useCase.do("car1")

      # Then I get the number of minutes the car was booked for
      expect(bookingDuration).to be_a(Integer)
    end
  end
end
