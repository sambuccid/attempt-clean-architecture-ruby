require 'json'
require './frameworks/settings'
require 'carpark/use_case/SlotsUseCase'
require './repository/MemoryRepository'
require 'carpark/domain/exceptions/ParkIsFull'
require 'carpark/domain/exceptions/InvalidSlot'
require 'carpark/domain/exceptions/DuplicateCar'
require 'carpark/domain/exceptions/CarNotExisting'
require './controller/helper/ControllerHelper'

class Controller
  include ControllerHelper

  def initialize(setting = Setting.new)
    @setting = setting

    @memRepository = MemoryRepository.new(setting)
    @slotUseCase = SlotsUseCase.new(@memRepository)
  end

  def availableParkSlots
    availableSlots = @slotUseCase.availableSlots
    success availableSlots.to_json
  end

  def checkInCar(name)
    error = paramExists? name, "'name' parameter missing"
    return error if !error.nil?
    
    begin
      assignedSlot = @slotUseCase.addCar(name)
      success( { slot: assignedSlot }.to_json )
    rescue ParkIsFull
      return userError 'no slot available'
    rescue DuplicateCar
      return userError "Car '#{name}' is already checked in"
    end
  end

  def findCarIn(slot)
    error = paramExists? slot, "'slot' parameter missing"
    return error if !error.nil?

    error = validateParam slot, "'slot' should be a number" do
      |slot| /\A\d+\z/.match(slot)
    end
    return error if !error.nil?

    slot = slot.to_i
    begin
      carName = @slotUseCase.getCarIn(slot)
      success( {car: carName}.to_json )
    rescue InvalidSlot
      notFound "The specified slot doesn't exist"
    end
  end


  # post '/check-out-car' do
  #   param_exists :name, "'name' parameter missing"
  #   begin
  #     @slotUseCase.removeCar(params["name"])
  #     nil
  #   rescue CarNotExisting
  #     user_error_400 'car is not in the park'
  #   end
  # end

  # configure do
  #   set :show_exceptions, true
  #   enable :dump_errors,:raise_errors
  #   use Rack::ShowExceptions
  # end
end