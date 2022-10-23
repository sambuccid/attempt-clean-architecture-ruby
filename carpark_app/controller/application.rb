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
require './controller/Controller'

class Application < Sinatra::Base
  def initialize(setting = Setting.new)
    super

    memRepository = MemoryRepository.new(setting)
    slotUseCase = SlotsUseCase.new(memRepository)
    @controller = Controller.new(setting, memRepository, slotUseCase)
  end

  def processControllerReturn(controllerReturn)
    status controllerReturn[:status]
    body controllerReturn[:body]
  end

  get '/available-park-slots' do
    ret = @controller.availableParkSlots
    processControllerReturn(ret)
  end

  post '/check-in-car' do
    name = params["name"]
    ret = @controller.checkInCar(name)
    processControllerReturn(ret)
  end

  get '/find-car-in' do
    slot = params["slot"]
    ret = @controller.findCarIn(slot)
    processControllerReturn(ret)
  end


  post '/check-out-car' do
    ret = @controller.checkOutCar(params["name"])
    processControllerReturn(ret)
  end

  configure do
    set :show_exceptions, true
    enable :dump_errors,:raise_errors
    use Rack::ShowExceptions
  end
end


