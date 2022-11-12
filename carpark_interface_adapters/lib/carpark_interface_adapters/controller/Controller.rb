require 'json'
require 'carpark/domain/exceptions/ParkIsFull'
require 'carpark/domain/exceptions/InvalidSlot'
require 'carpark/domain/exceptions/DuplicateCar'
require 'carpark/domain/exceptions/CarNotExisting'
require 'carpark_interface_adapters/controller/helper/ControllerHelper'
require 'carpark/use_case/AvailableSlotsUC'
require 'carpark/use_case/BookSlotUC'
require 'carpark/use_case/GetCarInSlotUC'
require 'carpark/use_case/CheckOutUC'

class Controller
  include ControllerHelper

  def initialize(repository)
    @availableSlotsUC = AvailableSlotsUC.new(repository)
    @bookSlotUC = BookSlotUC.new(repository)
    @getCarInSlotUC = GetCarInSlotUC.new(repository)
    @checkOutUC = CheckOutUC.new(repository)
  end

  def availableParkSlots
    availableSlots = @availableSlotsUC.do
    success availableSlots.to_json
  end

  def checkInCar(name)
    error = paramExists? name, "'name' parameter missing"
    return error if !error.nil?
    
    begin
      assignedSlot = @bookSlotUC.do(name)
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
      carName = @getCarInSlotUC.do(slot)
      success( {car: carName}.to_json )
    rescue InvalidSlot
      notFound "The specified slot doesn't exist"
    end
  end

  def checkOutCar(name)
    error = paramExists? name, "'name' parameter missing"
    return error if !error.nil?

    begin
      duration = @checkOutUC.do(name)
      success( {duration: duration}.to_json )
    rescue CarNotExisting
      userError 'car is not in the park'
    end
  end
end
