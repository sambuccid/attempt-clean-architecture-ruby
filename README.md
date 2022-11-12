# Attempt clean architecture Ruby
This was a project I used to try to apply Clean Architecture principles, hopefully it can be useful to other people as well.

# The project
The project is about managing a carpark, more infos about the [Business Requirements here] (Requirements.md)

The project is divided into 4 layers:
* domain
* use cases
* interface adapters
* infrastructure

To separate better the layers I divided the project into 3 parts:
* **carpark**: a ruby gem with the domain and the use cases layers
* **carpark_interface_adapters**: a ruby gem with the interface adapters layer
* **app**: a ruby project with the infrastructure layer

In this way it's not possible for the carpark gem(domain and use cases) to use any code from the interface adapters.

While the carpark_interface_adapters(interface adapters) import the carpark gem and can use it.

And in the outer layer we have the app folder that imports all the previous gems and the framework. Having this layer separated from the others is particularly important as it ensures that it's not possible in inner layers to depend on any functionality of the framework.

### carpark
This is a gem containing the domain objects and the use cases.

The domain layer contains just 2 objects and the only logic inside it is about managing a list of car park slots.
While the use cases layer contains the actions that a user can do, with all the logic needed to perform the action.

The use cases are defined using the command pattern, this makes them responsible for a single functionality and it makes easier to look at the file structure and tell what the application does([Screaming Architecture](http://blog.cleancoder.com/uncle-bob/2011/09/30/Screaming-Architecture.html))

The use cases accept and return just simple string or numbers, so this means thet there was no need for having Interfaces between use cases and interface adapters.

### carpark_interface_adapters
This is a gem containing the controllers and repositories, it imports the carpark gem to be able to call the use cases

The repository is an in memory repository and it allows to load or save a domain object.
There isn't an Interface that the repository implements because in Ruby is not necessary to define an interface to be able to use 2 different implementations from the same code.

The controller is just one, and it does the job of both controller and presenter. This might violate the single responibility principle but there is so few code involved in presenting the data that having a separate presenter seems overkill.

The cotroller contains all the endpoints of the application and what it does is validate the input parameters, calling the use cases, and defining the results with the statusCode to return and the formatting of the data.

In this layer there are also tests that test all the functionalities of the application, they are written as unit tests but they don't mock any object and test the 3 inner layers.

### app
This is a ruby project that imports the "carpark" and the "carpark_interface_adapters" gems.

It contains the code to start the application and it defines the WebServer using the sinatra framework, its sole purpose is to connect controller with the framework and it delegates all the logic to the interface adapters.

### How to run
The project uses ruby 3.1.0, so you'll need it installed alongside bunder.

Then to run the webserver just run the `server.sh` file.

While to run all the tests you can run the `tests.sh` file.
