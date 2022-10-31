require 'carpark/domain/Slot'
require 'set'
require 'carpark/domain/exceptions/CarNotExisting'
require 'carpark/domain/exceptions/DuplicateCar'
require 'carpark/domain/exceptions/InvalidName'
require 'carpark/domain/exceptions/InvalidSlot'
require 'carpark/domain/exceptions/ParkIsFull'

class SlotList
   EMPTY_VALUE = :nil

  def initialize(settings, slots=nil)
    @slots = Array.new(settings.max_slots)
    @slots.fill(EMPTY_VALUE)

    if !slots.nil?
      if slots.length() != settings.max_slots
        throw "error of initialisation"
      end

      slots.each_with_index do |slot, index|
        setSlotValue(index, slot)
      end
    end
  end

  def getAllSlotsAsArray
    @slots
  end

  def emptySlots
    @slots.count(EMPTY_VALUE)
  end

  def setSlot(carName, time)
    if full?
      raise ParkIsFull
    end
    idx = getFirstAvailableSlot
    slot = Slot.new(carName, time)
    setSlotValue(idx, slot)
    idx
  end

  def getSlot(slot)
    unless slotExist? slot
      raise InvalidSlot
    end
    if @slots[slot] == EMPTY_VALUE
      nil
    else
      @slots[slot]
    end
  end

  def getAllSlots()
    allSlots = []
    @slots.each_index do |index|
      allSlots[index] = getSlot(index)
    end
    allSlots
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
      return nil
    end
    timeBooked = @slots[slot].timeBooked
    setSlotValue(slot, EMPTY_VALUE)
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
      emptySlots <= 0
    end

    def slotExist?(slot)
      @slots.length() > slot
    end

    def setSlotValue(slotIdx, slot)
      @slots[slotIdx] = slot
    end
end
