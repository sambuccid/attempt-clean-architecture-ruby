require 'rspec'
require 'carpark_interface_adapters/repository/MemoryRepository'

describe MemoryRepository do
  MAX_SLOTS = 12

  context "create new MemoryRepository" do
    # in the case of MemoryRepository it will always initialise one, but a normal repository would do it only if there isn't one persisted already
    it "initialises and saves an empty SlotList" do
      # Given there is't any SlotList already persisted
      
      # When I create a new repository
      repository = MemoryRepository.new(MAX_SLOTS)

      # Then a new empty SlotList should have been created
      createdSlotList = repository.getSlotList
      expect(createdSlotList.emptySlots).to eq(MAX_SLOTS)
    end
  end
end
