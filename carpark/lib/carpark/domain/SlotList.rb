require 'carpark/domain/Slot'
require 'set'
require 'carpark/domain/exceptions/CarNotExisting'
require 'carpark/domain/exceptions/InvalidName'
require 'carpark/domain/exceptions/InvalidSlot'

class SlotList
   EMPTY_VALUE = :nil

  def initialize(max_slots, slots=nil)
    @slots = Array.new(max_slots)
    @slots.fill(EMPTY_VALUE)

    if !slots.nil?
      if slots.length() != max_slots
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

  def setSlot(slotNumber, carName, time)
    slot = Slot.new(carName, time)
    setSlotValue(slotNumber, slot)
    nil
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

  def emptySlot(slotNumber)
    if @slots[slotNumber] == EMPTY_VALUE
      return nil
    end
    slot = @slots[slotNumber]
    setSlotValue(slotNumber, EMPTY_VALUE)
    slot
  end

  def getFirstEmptySlot
    @slots.find_index {|slot| slot == EMPTY_VALUE}
  end

  def full?
    emptySlots <= 0
  end

  def max_slots
    @slots.length()
  end

  private

    def slotExist?(slot)
      @slots.length() > slot
    end

    def setSlotValue(slotIdx, slot)
      @slots[slotIdx] = slot
    end
end
