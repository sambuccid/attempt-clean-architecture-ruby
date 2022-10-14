require './layers/interface-adapters/entity/Slot'

class SlotList
   EMPTY_VALUE = :nil

  def initialize(settings, slots=nil)
    @slots = Array.new(settings.max_slots)
    @slots.fill(EMPTY_VALUE)
    @registeredCars = Set.new()

    if !slots.nil?
      if slots.length() != settings.max_slots
        throw "error of initialisation"
      end

      slots.each_with_index do |slot, index|
        setSlot(index, slot)
      end
    end
  end

  def getAllSlotsAsArray
    @slots
  end

  def availableSlots
    @slots.count(EMPTY_VALUE)
  end

  def bookSlot(carName)
    if full?
      raise ParkIsFull
    end
    idx = getFirstAvailableSlot
    slot = Slot.new(carName, Time.now)
    setSlot(idx, slot)
    idx
  end

  def getCarIn(slot)
    unless slotExist? slot
      raise InvalidSlot
    end
    if @slots[slot] == EMPTY_VALUE
      nil
    else
      @slots[slot].carName
    end
  end

  def slotOfCar(carName)
    if carName.nil?
      raise InvalidName
    end
    slot = @slots.find_index {|slot| slot!=EMPTY_VALUE && slot.carName == carName}
    raise CarNotExisting if slot.nil?
    slot
  end

  def emptySlot(slot)
    if @slots[slot] == EMPTY_VALUE
      nil
    end
    timeBooked = @slots[slot].timeBooked
    setSlot(slot, EMPTY_VALUE)
    bookingDurationSeconds = Time.now - timeBooked
    bookingDurationMinutes = (bookingDurationSeconds / 60).ceil
    bookingDurationMinutes
  end

  def slotBookTime(slot)
    @slots[slot].timeBooked
  end

  private
    def getFirstAvailableSlot
      @slots.find_index {|slot| slot == EMPTY_VALUE}
    end

    def full?
      availableSlots <= 0
    end

    def slotExist?(slot)
      @slots.length() > slot
    end

    def setSlot(slotIdx, slot)
      if slot != EMPTY_VALUE
        if @registeredCars.include?(slot.carName)
          raise DuplicateCar
        end
        @registeredCars.add(slot.carName)
      elsif @slots[slotIdx] != EMPTY_VALUE
        slotRemoved = @slots[slotIdx]
        @registeredCars.delete(slotRemoved.carName)
      end
      @slots[slotIdx] = slot
    end
end
