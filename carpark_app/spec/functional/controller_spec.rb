require './controller/Controller'
require 'rspec'
require 'securerandom'
require 'carpark/use_case/SlotsUseCase'
require './repository/MemoryRepository'

describe "Controller endpoints" do

  class MockedSetting
    def max_slots
      12
    end
  end

  let(:controller) {
    setting = MockedSetting.new
    memRepository = MemoryRepository.new(setting)
    slotUseCase = SlotsUseCase.new(memRepository)
    Controller.new(setting, memRepository, slotUseCase)
  }
  
  context "availableParkSlots" do
    let(:response) { controller.availableParkSlots }

    it "returns status 200 OK" do
      expect(response[:status]).to eq 200
    end

    it "returns all parking slots available when no cars got in" do
      expect(JSON.parse(response[:body])).to eq(MockedSetting.new.max_slots)
    end

    it "parking slot reduced when a car parks in" do
      controller.checkInCar("car1")
      expect(JSON.parse(response[:body])).to eq(MockedSetting.new.max_slots - 1)
    end
  end

  context "checkInCar" do
    let(:response) { controller.checkInCar("car1") }

    it "returns status 200 OK" do
      expect(response[:status]).to eq 200
    end

    it "returns associated parking slot" do
      expect(JSON.parse(response[:body])["slot"]).to be_a(Integer)
    end
  end

  context "Errors - checkInCar" do
    it "error if all slots full" do
      MockedSetting.new.max_slots.times do
        controller.checkInCar(SecureRandom.uuid)
      end
      #calling one last time
      resp = controller.checkInCar("car1")
      expect(resp[:status]).to eq(400)
      expect(JSON.parse(resp[:body])["message"]).to eq("no slot available")
    end

    it "errors if we don't pass a name" do
      resp = controller.checkInCar(nil)
      expect(resp[:status]).to eq(400)
      expect(JSON.parse(resp[:body])["message"]).to eq("'name' parameter missing")
    end

    it "errors if we pass an empty name" do
      resp = controller.checkInCar("")
      expect(resp[:status]).to eq(400)
      expect(JSON.parse(resp[:body])["message"]).to eq("'name' parameter missing")
    end

    it "errors if we book same car twice" do
      # Given I have booked in a car
      controller.checkInCar("car1")
      # When I book in the same car
      resp = controller.checkInCar("car1")
      # Then I get an error
      expect(resp[:status]).to eq(400)
      expect(JSON.parse(resp[:body])["message"]).to eq("Car 'car1' is already checked in")
    end
  end

  context "findCarIn" do
    let(:response) {
      resp = controller.checkInCar("ciccio")
      slot = JSON.parse(resp[:body])["slot"]
      slot = slot.to_s
      controller.findCarIn(slot)
    }

    it "returns status 200 OK" do
      expect(response[:status]).to eq 200
    end

    it "returns car name in that place" do
      expect(JSON.parse(response[:body])["car"]).to eq("ciccio")
    end
  end

  context "Errors: findCarIn" do
    it "returns empty car if the car in that slot was not found" do
      resp = controller.findCarIn("1")
      expect(JSON.parse(resp[:body])["car"]).to eq(nil)
    end

    it "returns 404 if the slot doesn't exist" do
      nonExistingSlot = MockedSetting.new.max_slots + 1
      nonExistingSlot = nonExistingSlot.to_s
      resp = controller.findCarIn(nonExistingSlot)
      expect(resp[:status]).to eq(404)
    end

    it "error if don't send slot parameter" do
      resp = controller.findCarIn(nil)
      expect(resp[:status]).to eq(400)
      expect(JSON.parse(resp[:body])["message"]).to eq("'slot' parameter missing")
    end

    it "error if don't send empty slot parameter" do
      resp = controller.findCarIn("")
      expect(resp[:status]).to eq(400)
      expect(JSON.parse(resp[:body])["message"]).to eq("'slot' parameter missing")
    end

    it "error if send a slot in wrong format" do
      resp = controller.findCarIn("not_a_number")
      expect(resp[:status]).to eq(400)
      expect(JSON.parse(resp[:body])["message"]).to eq("'slot' should be a number")
    end
  end

  context "checkOutCar" do
    it "returns status 200 OK" do
      # Given a car is already checked in
      controller.checkInCar("car1")
      # When I want to check it out
      resp = controller.checkOutCar("car1")
      # I can use checkOutCar
      expect(resp[:status]).to eq 200
    end

    it "empties the slot used by the car" do
      # Given a car is already checked in
      car = "car1"
      res = controller.checkInCar(car)
      slot = JSON.parse(res[:body])["slot"]
      slot = slot.to_s
      # When I check it out
      controller.checkOutCar(car)
      # The slot used by the car is empty
      res = controller.findCarIn(slot)
      expect(JSON.parse(res[:body])["car"]).to eq(nil)
    end

    it "gives error if name parameter not provided" do
      # Given I forget to specify a name parameter for a car
      carName = nil
      # When I try to check the car out
      res = controller.checkOutCar(carName)
      # Then I get an error
      expect(res[:status]).to eq 400
      expect(JSON.parse(res[:body])["message"]).to eq("'name' parameter missing")
    end

    it "gives error if name parameter is empty" do
      # Given I specify an empty name parameter for a car
      carName = ""
      # When I try to check the car out
      res = controller.checkOutCar(carName)
      # Then I get an error
      expect(res[:status]).to eq 400
      expect(JSON.parse(res[:body])["message"]).to eq("'name' parameter missing")
    end

    it "gives error if car doesn't exist" do
      # Given I misspell a car name and the car doesn't exist
      carName = "not_existing_car"
      # When I try to check the car out
      res = controller.checkOutCar(carName)
      # Then I get an error
      expect(res[:status]).to eq 400
      expect(JSON.parse(res[:body])["message"]).to eq("car is not in the park")
    end
  end
end
