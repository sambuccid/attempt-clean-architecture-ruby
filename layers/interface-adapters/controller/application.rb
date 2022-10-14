require 'sinatra'
require 'json'
require 'sinatra/base'
require 'sinatra/required_params'
require './layers/frameworks/settings'
require './layers/interface-adapters/use-case/SlotsUseCase'
require './layers/interface-adapters/repository/MemoryRepository'
require './layers/interface-adapters/entity/exceptions/ParkIsFull'
require './layers/interface-adapters/entity/exceptions/InvalidSlot'
require './layers/interface-adapters/entity/exceptions/DuplicateCar'
require './layers/interface-adapters/entity/exceptions/CarNotExisting'
require './layers/interface-adapters/controller/helper/AppHelper'

class Application < Sinatra::Base
  helpers Sinatra::RequiredParams
  include AppHelper

  def initialize(setting = Setting.new)
    super
    @setting = setting

    @memRepository = MemoryRepository.new(setting)
    @slotUseCase = SlotsUseCase.new(@memRepository)
  end

  get '/available-park-slots' do
    availableSlots = @slotUseCase.availableSlots
    availableSlots.to_json
  end

  post '/check-in-car' do
    param_exists :name, "'name' parameter missing"
    name = params["name"]
    begin
      assignedSlot = @slotUseCase.addCar(name)
      { slot: assignedSlot }.to_json
    rescue ParkIsFull
      user_error_400 'no slot available'
    rescue DuplicateCar
      user_error_400 "Car '#{name}' is already checked in"
    end
  end

  get '/find-car-in' do
    param_exists :slot, "'slot' parameter missing"
    validate_param :slot, "'slot' should be a number" do
      |slot| /\A\d+\z/.match(slot)
    end

    slot = params["slot"].to_i
    begin
      carName = @slotUseCase.getCarIn(slot)
      {car: carName}.to_json
    rescue InvalidSlot
      status 404
      response_body = { message: "The specified slot doesn't exist" }
      body response_body.to_json
    end
  end


  post '/check-out-car' do
    param_exists :name, "'name' parameter missing"
    begin
      @slotUseCase.removeCar(params["name"])
      nil
    rescue CarNotExisting
      user_error_400 'car is not in the park'
    end
  end

  configure do
    set :show_exceptions, true
    enable :dump_errors,:raise_errors
    use Rack::ShowExceptions
  end
end


