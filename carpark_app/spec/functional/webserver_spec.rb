require './lib/controller/WebServer'
require 'rspec'
require 'rack/test'

describe WebServer do
 include Rack::Test::Methods

  class MockedSetting
    def max_slots
      12
    end
  end

  let(:app) { WebServer.new(MockedSetting.new) }

  context "Get to /available-park-slots" do
    let(:response) { get "/available-park-slots" }

    it "returns status 200 OK" do
      expect(response.status).to eq 200
    end
  end

  context "Post to /check-in-car" do
    let(:response) { post "/check-in-car", {name: "car1"} }

    it "returns status 200 OK" do
      expect(response.status).to eq 200
    end
  end

  context "Get to /find-car-in" do
    let(:response) {
      resp = post 'check-in-car', {name: "car1"}
      slot = JSON.parse(resp.body)["slot"]
      get "/find-car-in", {slot: slot}
    }

    it "returns status 200 OK" do
      expect(response.status).to eq 200
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
  end
end
