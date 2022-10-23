class Slot
  attr_reader :carName, :timeBooked

  def initialize(carName, timeBooked)
    @carName = carName
    @timeBooked = timeBooked
  end
end
