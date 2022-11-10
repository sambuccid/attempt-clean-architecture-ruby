require 'rspec'
require 'carpark/use_case/CheckOutUC'

describe CheckOutUC do
  MAX_SLOTS = 12

  context "check out a car" do
    def create_repository_returning(slotList)
      repository = double
      allow(repository).to receive(:getSlotList).and_return(slotList)
      allow(repository).to receive(:saveSlotList)
      repository
    end

    it "gives back how long the slot was occupied for" do
      # Given I booked a slot
      slotList = SlotList.new(MAX_SLOTS)
      slotList.setSlot(0, "car1", Time.now)

      repository = create_repository_returning(slotList)
      useCase = CheckOutUC.new(repository)

      # When I check out the car
      bookingDuration = useCase.do("car1")

      # Then I get the number of minutes the car was booked for
      expect(bookingDuration).to be_a(Integer)
    end

    it "the duration we get back is correct" do
      # Given we booked a slot 13 minutes ago
      slotList = SlotList.new(MAX_SLOTS)
      slotList.setSlot(0, "car1",  Time.now - 13*60)

      repository = create_repository_returning(slotList)
      useCase = CheckOutUC.new(repository)

      # When I check out the car
      bookingDuration = useCase.do("car1")

      # Then I get back the correct duration in minutes
      expect(bookingDuration).to eq(13).or eq(14)
    end
  end
end
