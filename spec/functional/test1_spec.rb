require './layers/interface-adapters/controller/application'
require 'rspec'
require 'rack/test'
require './layers/frameworks/settings'
require 'securerandom'

describe Application do
  include Rack::Test::Methods

  class MockedSetting
    def max_slots
      12
    end
  end

  let(:app) { Application.new(MockedSetting.new) }

  context "Get to /available-park-slots" do
    let(:response) { get "/available-park-slots" }

    it "returns status 200 OK" do
      expect(response.status).to eq 200
    end

    it "returns all parking slots available when no cars got in" do
      expect(JSON.parse(response.body)).to eq(MockedSetting.new.max_slots)
    end

    it "parking slot reduced when a car parks in" do
      post 'check-in-car', {name: "car1"}
      expect(JSON.parse(response.body)).to eq(MockedSetting.new.max_slots - 1)
    end
  end

  context "Post to /check-in-car" do
    let(:response) { post "/check-in-car", {name: "car1"} }

    it "returns status 200 OK" do
      expect(response.status).to eq 200
    end

    it "returns associated parking slot" do
      expect(JSON.parse(response.body)["slot"]).to be_a(Integer)
    end
  end

  context "Errors - Post to /check-in-car" do
    it "error if all slots full" do
      MockedSetting.new.max_slots.times do
        post "/check-in-car", {name: SecureRandom.uuid}
      end
      #calling one last time
      resp = post "/check-in-car", {name: "car1"}
      expect(resp.status).to eq(400)
      expect(JSON.parse(resp.body)["message"]).to eq("no slot available")
    end

    it "errors if we don't pass a name" do
      resp = post "/check-in-car"
      expect(resp.status).to eq(400)
      expect(JSON.parse(resp.body)["message"]).to eq("'name' parameter missing")
    end

    it "errors if we pass an empty name" do
      resp = post "/check-in-car", {name: ""}
      expect(resp.status).to eq(400)
      expect(JSON.parse(resp.body)["message"]).to eq("'name' parameter missing")
    end

    it "errors if we book same car twice" do
      # Given I have booked in a car
      post "/check-in-car", {name: "car1"}
      # When I book in the same car
      resp = post "/check-in-car", {name: "car1"}
      # Then I get an error
      expect(resp.status).to eq(400)
      expect(JSON.parse(resp.body)["message"]).to eq("Car 'car1' is already checked in")
    end

    it "returns the only available parking slot" do
      throw "to implement"
      # expect(JSON.parse(response.body)["slot"]).to be_a(Integer)
    end
  end

  context "Get to /find-car-in" do
    let(:response) {
      resp = post 'check-in-car', {name: "ciccio"}
      slot = JSON.parse(resp.body)["slot"]
      get "/find-car-in", {slot: slot}
    }

    it "returns status 200 OK" do
      expect(response.status).to eq 200
    end

    it "returns car name in that place" do
      expect(JSON.parse(response.body)["car"]).to eq("ciccio")
    end
  end

  context "Get to /find-car-in" do
    it "returns empty car if the car in that slot was not found" do
      resp = get "/find-car-in", {slot: 1}
      expect(JSON.parse(resp.body)["car"]).to eq(nil)
    end

    it "returns 404 if the slot doesn't exist" do
      resp = get "/find-car-in", {slot: MockedSetting.new.max_slots + 1}
      expect(resp.status).to eq(404)
    end

    it "error if don't send slot parameter" do
      resp = get "/find-car-in"
      expect(resp.status).to eq(400)
      expect(JSON.parse(resp.body)["message"]).to eq("'slot' parameter missing")
    end

    it "error if don't send empty slot parameter" do
      resp = get "/find-car-in", {slot: ""}
      expect(resp.status).to eq(400)
      expect(JSON.parse(resp.body)["message"]).to eq("'slot' parameter missing")
    end

    it "error if send a slot in wrong format" do
      resp = get "/find-car-in", {slot: "not_a_number"}
      expect(resp.status).to eq(400)
      expect(JSON.parse(resp.body)["message"]).to eq("'slot' should be a number")
    end
  end

  context "Post to /check-out-car" do

    it "returns status 200 OK" do
      # Given a car is already checked in
      post "/check-in-car", {name: "car1"}
      # When I want to check it out
      resp = post "/check-out-car", {name: "car1"}
      # I have an endpoint to call
      expect(resp.status).to eq 200
    end

    it "empties the slot used by the car" do
      # Given a car is already checked in
      car = "car1"
      res = post "/check-in-car", {name: car}
      slot = JSON.parse(res.body)["slot"]
      # When I check it out
      post "/check-out-car", {name: car}
      # The slot used by the car is empty
      res = get "/find-car-in", {slot: slot}
      expect(JSON.parse(res.body)["car"]).to eq(nil)
    end

    #TODO
    it "returns for how long the slot was booked in the right format" do
      throw "Need to implement this"
    end

    it "gives error if name parameter not provided" do
      # Given I forget to specify a name parameter for a car
      carName = nil
      # When I try to check the car out
      res = post "/check-out-car", {name: carName}
      # Then I get an error
      expect(res.status).to eq 400
      expect(JSON.parse(res.body)["message"]).to eq("'name' parameter missing")
    end

    it "gives error if name parameter is empty" do
      # Given I specify an empty name parameter for a car
      carName = ""
      # When I try to check the car out
      res = post "/check-out-car", {name: carName}
      # Then I get an error
      expect(res.status).to eq 400
      expect(JSON.parse(res.body)["message"]).to eq("'name' parameter missing")
    end

    it "gives error if car doesn't exist" do
      # Given I misspell a car name and the car doesn't exist
      carName = "not_existing_car"
      # When I try to check the car out
      res = post "/check-out-car", {name: carName}
      # Then I get an error
      expect(res.status).to eq 400
      expect(JSON.parse(res.body)["message"]).to eq("car is not in the park")
    end
  end
end
