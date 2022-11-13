# Attempt to Clean Architecture in Ruby
This was a project I used to try to apply Clean Architecture principles, hopefully it can be useful to other people as well.

# The project
The project is about managing a carpark, here there are the [Business Requirements](./Requirements.md) I used.

The project is divided into 4 layers:
* domain
* use cases
* interface adapters
* infrastructure

To separate better the layers I divided the project into 3 parts:
* **carpark**: a ruby gem with the domain and the use cases layers
* **carpark_interface_adapters**: a ruby gem with the interface adapters layer
* **app**: a folder where I import the other gems, with the infrastructure layer

In this way it's not possible for the `carpark` gem(domain and use cases) to use any code from the interface adapters.

While the `carpark_interface_adapters`(interface adapters) imports the `carpark` gem and can use it.

And in the outer layer we have the app folder that contians the framework. Having this layer separated from the others is particularly important as it ensures that it's not possible in inner layers to depend on any part of the framework.

### carpark
This is a gem containing the domain objects and the use cases.

The **domain** layer contains 2 objects and it doesn't contain much logic.
While the **use cases** layer contains the actions that a user can do, with all the logic needed to perform the action.

The **use cases** are defined using the command pattern, and they accept and return just simple string or numbers, so I haven't defined Interfaces to represents **in and out Ports** between use cases and interface adapters.

### carpark_interface_adapters
This is a gem containing the controllers and repositories, it imports the carpark gem to be able to call the use cases.

The only repository is implemented in memory, it doesn't implement any Interface because in Ruby they are not strictly necessary.

The controller is just one, and it does the job of both controller and presenter. This might violate the single responibility principle but there is very little code involved in presenting the data.

The cotroller contains all the endpoints of the application, validation of input parameters, and the formatting of the results.

In this layer there are also tests that test all the functionalities of the application.

### app
This is a ruby project that imports the "carpark" and the "carpark_interface_adapters" gems.

It contains the code to start the application and it defines the WebServer using the sinatra framework, its sole purpose is to connect controller with the framework delegating all the rest to the other layers.

### How to run
The project uses ruby 3.1.0, so you'll need it installed alongside bunder.

Then to run the webserver just run the `server.sh` file.

While to run all the tests you can run the `tests.sh` file.
