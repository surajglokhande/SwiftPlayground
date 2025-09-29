//: [Previous](@previous)
/*:
## Single Responsibility Principle (SRP):
The SRP states that a class should have only one reason to change, meaning it should have a single responsibility. By keeping classes focused on a specific task, we achieve higher cohesion and reduce the potential for code duplication or bloated classes. This principle helps us to keep our classes as clean as possible.
 */
import Foundation
struct User {
	var name: String
	var age: Int
}

class UserManager {
	func addUser(_ user: User) {
			// Code to add a user to the system
	}

	func removeUser(_ user: User) {
			// Code to remove a user from the system
	}
}

class UserViewController {
	let userManager = UserManager()

	func addUserButtonTapped() {
		let user = User(name: "Ankit", age: 25)
		userManager.addUser(user)
	}

	func removeUserButtonTapped() {
		let user = User(name: "Ankit", age: 25)
		userManager.removeUser(user)
	}
}
//: [Next](@next)
