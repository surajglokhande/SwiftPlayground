//: [Previous](@previous)
/*:
 ## Polymorphism
 ## Static Dispatch (Compile-Time Dispatch)
 
 - It allows objects of different classes to be treated as objects of a common superclass or a common protocol type.
 
 **There are two primary ways polymorphism works in Swift:**
 
 **Inheritance-based:** where a subclass object can be treated as an instance of its superclass.
 
 - This type of polymorphism relies on the concept of inheritance. If ClassB inherits from ClassA, then an instance of ClassB can be used wherever an instance of ClassA is expected.
 
 **How it works:**

 - **Superclass Reference:** You define a variable or parameter with the type of a superclass.
 - **Subclass Assignment:** You assign an instance of a subclass to that superclass-typed variable/parameter.
 - **Method Overriding:** Subclasses can override methods defined in their superclass. When the method is called on the superclass-typed variable, the actual implementation from the subclass (if overridden) is executed at runtime. This is achieved through dynamic dispatch.
 */
import Foundation
// Superclass
class Vehicle {
    let make: String
    let model: String

    init(make: String, model: String) {
        self.make = make
        self.model = model
    }

    func startEngine() {
        print("\(make) \(model): Engine started with a generic hum.")
    }

    func drive() {
        print("\(make) \(model): Driving down the road.")
    }
}

// Subclass 1
class Car: Vehicle {
    let numberOfDoors: Int

    init(make: String, model: String, numberOfDoors: Int) {
        self.numberOfDoors = numberOfDoors
        super.init(make: make, model: model)
    }

    // Overriding the startEngine method
    override func startEngine() {
        print("\(make) \(model): Car engine roars to life!")
    }

    func openTrunk() {
        print("\(make) \(model): Trunk opened.")
    }
}

// Subclass 2
class Motorcycle: Vehicle {
    let hasSideCar: Bool

    init(make: String, model: String, hasSideCar: Bool) {
        self.hasSideCar = hasSideCar
        super.init(make: make, model: model)
    }

    // Overriding the startEngine method
    override func startEngine() {
        print("\(make) \(model): Motorcycle engine sputters and kicks on!")
    }

    func leanIntoTurn() {
        print("\(make) \(model): Leaning into the turn.")
    }
}

// --- Demonstrating Subtype Polymorphism ---

// Create an array that holds Vehicle objects
var garage: [Vehicle] = []

// Add instances of different subclasses to the array
garage.append(Car(make: "Honda", model: "Civic", numberOfDoors: 4))
garage.append(Motorcycle(make: "Harley-Davidson", model: "Fat Boy", hasSideCar: false))
garage.append(Vehicle(make: "Generic", model: "Scooter")) // Can also add the superclass itself

print("--- Starting all vehicles ---")
for vehicle in garage {
    // This `startEngine()` call is polymorphic.
    // The actual method executed depends on the *runtime type* of 'vehicle'.
    vehicle.startEngine() // Dynamic Dispatch
    vehicle.drive()       // Dynamic Dispatch (calls base implementation if not overridden)
    print("-------------------------")

    // You cannot directly call `openTrunk()` or `leanIntoTurn()` here
    // because `vehicle` is statically typed as `Vehicle`,
    // and those methods are not defined in `Vehicle`.
    // To access them, you would need to downcast (e.g., `if let car = vehicle as? Car`).
}

/* Expected Output:
--- Starting all vehicles ---
Honda Civic: Car engine roars to life!
Honda Civic: Driving down the road.
-------------------------
Harley-Davidson Fat Boy: Motorcycle engine sputters and kicks on!
Harley-Davidson Fat Boy: Driving down the road.
-------------------------
Generic Scooter: Engine started with a generic hum.
Generic Scooter: Driving down the road.
-------------------------
*/
/*:
 **Protocol-based:** Allowing types that conform to a specific protocol to be treated uniformly, regardless of their class or struct hierarchy.
 
 - Swift's protocols are incredibly powerful for achieving polymorphism without relying on inheritance. Any type (class, struct, enum) that conforms to a protocol can be treated as an instance of that protocol type.
 
 **How it works:**

 - **Protocol Definition:** You define a protocol that specifies a set of properties or methods.
 - **Type Conformance:** Different types (classes, structs, enums) declare conformance to this protocol and implement its requirements.
 - **Protocol Reference:** You define a variable or parameter with the type of the protocol.
 - **Conforming Type Assignment:** You assign an instance of any type that conforms to that protocol to the protocol-typed variable/parameter.
 */
// Protocol Definition
protocol Inspectable {
    func inspect() -> String
}

// Class conforming to Inspectable
class Book: Inspectable {
    let title: String
    let author: String

    init(title: String, author: String) {
        self.title = title
        self.author = author
    }

    func inspect() -> String {
        return "Book: '\(title)' by \(author)"
    }

    func readPage() {
        print("Reading a page from \(title).")
    }
}

// Struct conforming to Inspectable
struct Laptop: Inspectable {
    let brand: String
    let model: String

    func inspect() -> String {
        return "Laptop: \(brand) \(model)"
    }

    func bootUp() {
        print("Booting up the \(brand) \(model).")
    }
}

// Enum conforming to Inspectable
enum Fruit: String, Inspectable {
    case apple = "Apple"
    case banana = "Banana"
    case orange = "Orange"

    func inspect() -> String {
        return "Fruit: \(self.rawValue)"
    }

    func peel() {
        print("Peeling the \(self.rawValue).")
    }
}

// --- Demonstrating Protocol-based Polymorphism ---

// Create an array that holds Inspectable objects
var itemsToInspect: [Inspectable] = []

// Add instances of different types that conform to Inspectable
itemsToInspect.append(Book(title: "The Great Gatsby", author: "F. Scott Fitzgerald"))
itemsToInspect.append(Laptop(brand: "Apple", model: "MacBook Pro"))
itemsToInspect.append(Fruit.banana)

print("\n--- Inspecting all items ---")
for item in itemsToInspect {
    // This `inspect()` call is polymorphic.
    // The actual method executed depends on the *runtime type* of 'item'
    // and its conformance to the Inspectable protocol.
    print(item.inspect())
    print("-------------------------")

    // Just like with inheritance, you cannot directly call `readPage()`
    // or `bootUp()` or `peel()` here, because `item` is statically
    // typed as `Inspectable`, and those methods are not part of the protocol.
    // You would need to conditionally cast if you wanted to access them:
    // if let book = item as? Book {
    //     book.readPage()
    // }
}

/* Expected Output:
--- Inspecting all items ---
Book: 'The Great Gatsby' by F. Scott Fitzgerald
-------------------------
Laptop: Apple MacBook Pro
-------------------------
Fruit: Banana
-------------------------
*/
/*:
 ## Static Dispatch (Compile-Time Dispatch)
 
 **How it works:**
 
 - With static dispatch, the specific method implementation to be called is determined at compile time. The compiler knows exactly which function to execute based on the type information available at that moment.
 
 **Characteristics:**

 **Faster Performance:** Since the method call is resolved at compile time.
 
 **Less Flexible:** It doesn't allow for runtime polymorphism where the exact method to call depends on the actual type of an object, rather than its declared type.
 
 **Used for:**
 - **Value Types:** structs and enums in Swift always use static dispatch for their methods because they don't support inheritance.
 - **final Classes and Methods:** If a class or a method within a class is marked with the final keyword, it cannot be overridden. This allows the compiler to use static dispatch.
 - **private and fileprivate Methods:** These methods are not visible outside their scope, meaning they cannot be overridden by subclasses in other files. Swift can often optimize these to use static dispatch.
 - **Protocol Extension Methods (Non-@objc):** Methods defined directly in a protocol extension for value types, or for reference types where the method is not part of the protocol's primary requirements, often use static dispatch.
 - **Global and Static Functions:** These are directly addressed and use static dispatch.
 
 **How Swift Decides**

 - Swift generally prioritizes static dispatch for performance, but uses dynamic dispatch where polymorphism is required. Here's a simplified decision process:

 - **Value Types (struct, enum):** Always static dispatch (no inheritance).
 - **final Classes/Methods:** Static dispatch (no overriding allowed).
 - **private/fileprivate Methods:** Often static dispatch (compiler can optimize as they can't be overridden externally).
 
 - **Reference Types (class):**
    - If a method can be overridden by a subclass (not final), it defaults to dynamic dispatch (via a v-table lookup).
    - If a method needs to interact with the Objective-C runtime (@objc or dynamic), it uses Objective-C message sending, which is a form of dynamic dispatch.
 - **Protocol Extensions:**
    - If the method is part of the protocol's requirements, it will be dynamically dispatched (v-table for classes, or if @objc, message sending).
    - If the method is only in the extension and not a protocol requirement, it will be statically dispatched based on the static type of the variable. This can lead to surprising behavior sometimes, known as "protocol extension dispatch."
 */
//: [Next](@next)
