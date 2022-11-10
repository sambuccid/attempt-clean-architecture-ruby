# Business Requirements

## The system
We have a car park, and we are creating a system that helps with the management of the car park.
The system doesn't fully substitute the attendant of the car park but it helps them to run the car park, automating some processes.
So the user of the system is the attendand of the car park and somehow they access the system using directly the http endpoints.

## What does a car park attendant do
A list of some of the things that a car park attendant does, just to have something to drive the creation of features.
* a car wants to park, they assign a slot to the car
* they keep a note of the available slots that can be assigned
* they keep a record of when a car got in to know how much to charge for it
* when a car is about to leave, they calculate how much to charge them
* when the owner of a car comes back they reminds them the slot the car is in
* a car owner can provide the details of a debit card so the car can leave without stopping and they will charge them automatically
* they also sell subscriptions
  * the subscription is nominative and it is registered, currently the car should provide an ID and they can work out what type of subscription the car has
    * weekly
    * monthly
    * yearly
* who has a subscription, for a small additional fee, can ask to reserve a specific slot for them

## Possible Next features
### misc
* make the name of the car to be something unique like the plate
* have multiple floors/sections
  * perhaps also LPG cars can't go underground
* reserved spaces for an owner that has a subscription
