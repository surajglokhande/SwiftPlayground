//: [Previous](@previous)
/*:
 ## Dependency Inversion Principle (DIP):
 The DIP states that high-level modules should not depend on low-level modules; both should depend on abstractions. This principle encourages decoupling and promotes the use of interfaces or protocols to define contracts between components.
 */
/*:
 problem
 */
class Car  {
	func wheelNumber(){
		print("wheelNumber")
	}
	func hornType(){
		print("hornType")
	}
	func registrationNumber(){
		print("registrationNumber")
	}
	func vehicalColor(){
		print("vehicalColor")
	}
}
class Vehicle {
	let carObj: Car?

	init(carObj: Car) {
		self.carObj = carObj
	}

	func getVehicleInfo(){
			//access all function
		carObj?.hornType()
		carObj?.registrationNumber()
		carObj?.vehicalColor()
		carObj?.wheelNumber()
	}
}
var carOBJ = Vehicle(carObj: Car())
carOBJ.getVehicleInfo()
/*:
 respecting Dependency Inversion Principle (DIP)
 */
protocol CarOne {
	func wheelNumber()
}
protocol BikeOne {
	func wheelNumber()
	func hornType()
}

class VehicleOne: CarOne, BikeOne  {
	func hornType() {
		print("hornType")
	}
	func wheelNumber(){
		print("wheelNumber")
	}
}


class Demo {
	let objOne: CarOne?
	let objTwo: BikeOne?

	init(vehicleOne1obj: CarOne, vehicleOne2obj: BikeOne) {
		self.objOne = vehicleOne1obj
		self.objTwo = vehicleOne2obj
	}

	func getInfoOne(){
			//access only function which we want
		objOne?.wheelNumber()
			//		obj?.fun2()
			//		obj?.fun3()
			//		obj?.fun4()
	}

	func getInfoTwo(){
		objTwo?.wheelNumber()
		objTwo?.hornType()
	}
}


var demoOBJ1 = Demo(vehicleOne1obj: VehicleOne(), vehicleOne2obj: VehicleOne())
var demoOBJ2 = demoOBJ1
demoOBJ1.getInfoOne()
demoOBJ2.getInfoTwo()

/*:
    Problem One
 */

// Low-level module: Concrete EmailService
class EmailService {
    func sendEmail(to recipient: String, message: String) {
        print("Sending email to \(recipient): \(message)")
    }
}

// High-level module: OrderProcessor
class OrderProcessor {
    private let emailService = EmailService() // Direct dependency on a concrete implementation

    func processOrder(orderId: String, customerEmail: String) {
        print("Processing order \(orderId)...")
        // ... some order processing logic ...

        emailService.sendEmail(to: customerEmail, message: "Your order \(orderId) has been processed!")
    }
}

// Usage
let processor = OrderProcessor()
processor.processOrder(orderId: "A123", customerEmail: "customer@example.com")

/*:
    Solution One
 */

// 1. Abstraction (Protocol) - High-level and low-level modules depend on this
protocol NotificationService {
    func send(to recipient: String, message: String)
}

// 2. Low-level module: Concrete EmailService (depends on abstraction)
class EmailServiceOne: NotificationService {
    func send(to recipient: String, message: String) {
        print("Sending email to \(recipient): \(message)")
    }
}

// 3. Another Low-level module: Concrete SMSService (depends on abstraction)
class SMSService: NotificationService {
    func send(to recipient: String, message: String) {
        print("Sending SMS to \(recipient): \(message)")
    }
}

// 4. High-level module: OrderProcessor (depends on abstraction)
class OrderProcessorOne {
    private let notificationService: NotificationService // Depends on the abstraction (protocol)

    // Dependency Injection: The concrete implementation is "injected" from outside
    init(notificationService: NotificationService) {
        self.notificationService = notificationService
    }

    func processOrder(orderId: String, customerContact: String) {
        print("Processing order \(orderId)...")
        // ... some order processing logic ...

        notificationService.send(to: customerContact, message: "Your order \(orderId) has been processed!")
    }
}

// Usage
// We can now "inject" different notification services
let emailProcessor = OrderProcessorOne(notificationService: EmailServiceOne())
emailProcessor.processOrder(orderId: "B456", customerContact: "customer@example.com")

print("---")

let smsProcessor = OrderProcessorOne(notificationService: SMSService())
smsProcessor.processOrder(orderId: "C789", customerContact: "+919876543210")
/*:
    Problem Two
 */
// Not following DIP
class Service {
    // Service has a dependency on the concrete implementation
    private let database: Database = Database()
    func fetchData() {
        // Use the database to fetch data
    }
}
class Database {
    //
}
/*:
    Solution Two
 */
protocol DataService {
    func fetchData(completion: @escaping ([String]) -> Void)
}
class ViewModel {
    let dataService: DataService
    init(dataService: DataService) {
        self.dataService = dataService
    }
    func fetchData() {
        dataService.fetchData { data in
            // Process data
        }
    }
}
class RemoteDataService: DataService {
    func fetchData(completion: @escaping ([String]) -> Void) {
        // Fetch data from a remote server
    }
}
class LocalDataService: DataService {
    func fetchData(completion: @escaping ([String]) -> Void) {
        // Fetch data from a local database
    }
}
//: [Next](@next)
