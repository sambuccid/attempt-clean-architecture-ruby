require 'sinatra'
require 'json'
require 'sinatra/base'
require './frameworks/settings'
require 'carpark/use_case/SlotsUseCase'
require './repository/MemoryRepository'
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

  def self.passToController(method: nil, path: nil, controllerMethod: nil, parameter: nil)
    throw "Method missing" if method.nil?
    throw "Path missing" if path.nil?
    throw "controller method missing" if controllerMethod.nil?
    self.send method, path do
      ret = unless parameter.nil?
        param = params[parameter]
        @controller.send controllerMethod, param
      else
        @controller.send controllerMethod
      end
      processControllerReturn(ret)
    end
  end

  passToController(
    method: :get,
    path: '/available-park-slots',
    controllerMethod: :availableParkSlots
  )

  passToController(
    method: :post,
    path: '/check-in-car',
    controllerMethod: :checkInCar,
    parameter: "name"
  )

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


