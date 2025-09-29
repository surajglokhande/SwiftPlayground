//: [Previous](@previous)
/*:
 ## Open-Closed Principle (OCP):
 The OCP states that software entities should be open for extension but closed for modification. This principle encourages the use of abstraction and polymorphism, allowing new functionality to be added without modifying existing code.
 */
/*:
 problem One
 */
import Foundation
enum DeeplinkType {
	case home
	case profile
	case settings // Modification
}

protocol Deeplink {
	var type: DeeplinkType { get }
}

class SettingsDeeplink: Deeplink {
	let type: DeeplinkType = .settings

	func executeSettings() {
		debugPrint("Presents the Settings Screen")
	}
}

class HomeDeeplink: Deeplink {
	var type: DeeplinkType = .home

	func executeHome() {
		debugPrint("Presents the main screen")
	}
}

class ProfileDeeplink: Deeplink {
	let type: DeeplinkType = .profile

	func executeProfile() {
		debugPrint("Presents the profile screen")
	}
}

class Router {
	func execute(_ deeplink: Deeplink) {
		switch deeplink.type {
			case .home:
				(deeplink as? HomeDeeplink)?.executeHome()
			case .profile:
				(deeplink as? ProfileDeeplink)?.executeProfile()
					// Other Modification
			case .settings:
				(deeplink as? SettingsDeeplink)?.executeSettings()
		}
	}
}

let router = Router()
let home = HomeDeeplink()
router.execute(home)

/*:
 problem Two
 */
struct Invoice {
	//
}
class InvoicePersistence {
	let invoice: Invoice

	public init(invoice: Invoice) {
		self.invoice = invoice
	}

	public func saveToFile(filename: String) {
			// Creates a file with given name and writes the invoice
	}

	public func saveToDataBase(filename: String) {
			// save invoide in Database
	}
}
/*:
 respectiong Open-Closed Principle Problem Two
 */
protocol InvoicePersistence_s {
	func save(filename: String)
}

class FilePersistence: InvoicePersistence_s {
	let invoice: Invoice

	public init(invoice: Invoice) {
		self.invoice = invoice
	}

	public func save(filename: String) {
			// Creates a file with given name and writes the invoice
        print("FilePersistence")
	}
}
class DatabasePersistence: InvoicePersistence_s {
	let invoice: Invoice

	public init(invoice: Invoice) {
		self.invoice = invoice
	}

	public func save(filename: String) {
			// save invoice in Database
        print("DatabasePersistence")
	}
}
class PersistanceTest {
    var obj: InvoicePersistence_s?
    
    init(persistenceObj: InvoicePersistence_s) {
        self.obj = persistenceObj
    }
    
    func execute(file: String) {
        obj?.save(filename: file)
    }
}
var file = FilePersistence(invoice: Invoice())
var database = DatabasePersistence(invoice: Invoice())
var finalObj = PersistanceTest(persistenceObj: database)
finalObj.execute(file: "fileDatabase")
/*:
 respectiong Open-Closed Principle Problem One
 */
protocol Deeplink_s {
	func execute()
}

class HomeDeeplink_s: Deeplink_s {
	func execute() {
		debugPrint("Presents the Home Screen")
	}
}

class ProfileDeeplink_s: Deeplink_s {
	func execute() {
		debugPrint("Presents the Profile Screen")
	}
}

class SettingsDeeplink_s: Deeplink_s {
	func execute() {
		debugPrint("Presents the Settings Screen")
	}
}

class Router_s {
	func execute(_ deeplink: Deeplink_s) {
		deeplink.execute()
	}
}

var router_s = Router_s()
router_s.execute(SettingsDeeplink_s())
//: [Next](@next)
