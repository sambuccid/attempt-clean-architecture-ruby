# Planning

## The system
We have a car park, and we are creating a system that helps with the management of the car park.
The system doesn't fully substitute a car-park-holder(not yet) but it helps them to run the car park, automating some processes.
So the user of the system is a car-park-holder and we are supposing somehow that they access the system using directly the http endpoints.

## What does a car-park-holder do
Modeling what a car-park-holder does, just to have something to drive the creation of features.
* a car wants to get a slot to park, they assign a slot to the car
* they keeps a note of the available spaces that can be assigned
* they keeps a record of when a car got in to know how much to charge for it
* when a car is about to leaves, they calculate how much to charge and charge them
* when the owner comes back they reminds them the slot they had
* a car can provide the details of a debit card so the car can leave without stopping and they will charge them automatically
* they also sell subscriptions
  * the subscription is nominative and it is registered, currently the car should provide an ID and they can work out what type of subscriptions the car has
    * weekly
    * monthly
    * yearly
* who has a subscription, for a small additional fee, can ask to reserve a specific slot for them
* based on the car type they will avoid giving specific slots(ex. a GPL car can't go underground)

## What we have so far
### endpoints
* get how many slots are still available
* add a car to a slot
* name cars
* identitfy car in specific slot

## Possible ToDos
### misc
* ~~validation of data in input~~
* make the name of the car to be something that we actually use(is it the plate? in that case should it be unique? or maybe it's the name of the owner of the car)
* multiple floors/sections
  * perhaps also GPL cars can't go underground
* reserved spaces
### endpoints
* checkout of a car
  * ~~it empties the slot~~
  * **it returns the duration of how long the car has been there**
  * based on settings it returns the price to pay
    * it could even manage different tariffs based on how long it had been there
    * probably for a car with a subscription it should return 0 to pay

