require 'sinatra'
require 'json'
require 'sinatra/base'
require 'sinatra/required_params'
require './frameworks/settings'
require 'carpark/use_case/SlotsUseCase'
require './repository/MemoryRepository'
require 'carpark/domain/exceptions/ParkIsFull'
require 'carpark/domain/exceptions/InvalidSlot'
require 'carpark/domain/exceptions/DuplicateCar'
require 'carpark/domain/exceptions/CarNotExisting'
require './controller/helper/AppHelper'
require './controller/Controller'

class Application < Sinatra::Base
  helpers Sinatra::RequiredParams
  include AppHelper

  def initialize(setting = Setting.new)
    super
    @setting = setting

    @memRepository = MemoryRepository.new(setting)
    @slotUseCase = SlotsUseCase.new(@memRepository)
    @controller = Controller.new(@setting)
  end

  get '/available-park-slots' do
    ret = @controller.availableParkSlots
    processControllerReturn(ret)
    # availableSlots = @slotUseCase.availableSlots
    # availableSlots.to_json
  end

  post '/check-in-car' do
    # param_exists :name
    name = params["name"]
    ret = @controller.checkInCar(name)
    processControllerReturn(ret)
    # status ret[:status]
    # body ret[:body]
    # begin
    #   assignedSlot = @slotUseCase.addCar(name)
    #   { slot: assignedSlot }.to_json
    # rescue ParkIsFull
    #   user_error_400 'no slot available'
    # rescue DuplicateCar
    #   user_error_400 "Car '#{name}' is already checked in"
    # end
  end

  get '/find-car-in' do
    slot = params["slot"]
    ret = @controller.findCarIn(slot)
    processControllerReturn(ret)
    # status ret[:status]
    # body ret[:body]

    # param_exists :slot, "'slot' parameter missing"
    # validate_param :slot, "'slot' should be a number" do
    #   |slot| /\A\d+\z/.match(slot)
    # end

    # slot = params["slot"].to_i
    # begin
    #   carName = @slotUseCase.getCarIn(slot)
    #   {car: carName}.to_json
    # rescue InvalidSlot
    #   status 404
    #   response_body = { message: "The specified slot doesn't exist" }
    #   body response_body.to_json
    # end
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


