//: [Previous](@previous)
/*:
 **1. Component:** This is the interface or abstract class that defines the basic behavior of the objects that can be decorated. Both concrete components and decorators will implement this.

 **2. Concrete Component:** This is the original object to which responsibilities can be added. It implements the Component interface.

 **3. Decorator:** This is an abstract class or interface that mirrors the Component interface. It maintains a reference to a Component object and defines the interface for all concrete decorators.

 **4. Concrete Decorator:** These classes implement the Decorator interface and add specific responsibilities to the component. They wrap the component (or another decorator) and delegate the calls to the wrapped object, potentially adding their own logic before or after.

 **When to use it:**

 - To add responsibilities to individual objects dynamically and transparently, without affecting other objects.

 - To add responsibilities that can be withdrawn.

 - When extension by subclassing is impractical (e.g., when a large number of independent extensions are possible, leading to an explosion of subclasses).

 - To avoid a feature-laden class at the top of the hierarchy.
 */
import Foundation
/*:
    Component
 */
protocol Coffee {
    func cost() -> Double
    func description() -> String
}
/*:
    Concrete Component
 */
class SimpleCoffee: Coffee {
    func cost() -> Double {
        5.0
    }
    func description() -> String {
        "simple coffee"
    }
}
class ExpressoCoffee: Coffee {
    func cost() -> Double {
        7.0
    }
    func description() -> String {
        "Expresso coffee"
    }
}
/*:
    Decorator
 */
class DecoratorCoffee: Coffee {
    var decorator: Coffee
    init(coffee: Coffee) {
        self.decorator = coffee
    }
    func cost() -> Double {
        self.decorator.cost()
    }
    func description() -> String {
        self.decorator.description()
    }
}
/*:
    Concrete Decorator
 */
class MilkDecorator: DecoratorCoffee {
    override func cost() -> Double {
        self.decorator.cost() + 1.5
    }
    override func description() -> String {
        self.decorator.description() + ", Milk"
    }
}
class SugarDecorator: DecoratorCoffee {
    override func cost() -> Double {
        self.decorator.cost() + 0.5
    }
    override func description() -> String {
        self.decorator.description() + ", Sugar"
    }
}
class WhippedCreamDecorator: DecoratorCoffee {
    override func cost() -> Double {
        return decorator.cost() + 2.0
    }

    override func description() -> String {
        return decorator.description() + ", Whipped Cream"
    }
}
// MARK: - Client Usage

print("--- Coffee Orders ---")

// Order 1: Simple coffee
var myCoffee: Coffee = SimpleCoffee()
print("Order 1: \(myCoffee.description()) | Cost: $\(myCoffee.cost())") // Output: Simple Coffee | Cost: $5.0

// Order 2: Espresso with milk
myCoffee = ExpressoCoffee()
myCoffee = MilkDecorator(coffee: myCoffee)
print("Order 2: \(myCoffee.description()) | Cost: $\(myCoffee.cost())") // Output: Espresso, Milk | Cost: $8.5

// Order 3: Simple coffee with milk and sugar
myCoffee = SimpleCoffee()
myCoffee = MilkDecorator(coffee: myCoffee)
myCoffee = SugarDecorator(coffee: myCoffee)
print("Order 3: \(myCoffee.description()) | Cost: $\(myCoffee.cost())") // Output: Simple Coffee, Milk, Sugar | Cost: $7.0

// Order 4: Espresso with milk, sugar, and whipped cream
myCoffee = ExpressoCoffee()
myCoffee = MilkDecorator(coffee: myCoffee)
myCoffee = SugarDecorator(coffee: myCoffee)
myCoffee = WhippedCreamDecorator(coffee: myCoffee)
print("Order 4: \(myCoffee.description()) | Cost: $\(myCoffee.cost())") // Output: Espresso, Milk, Sugar, Whipped Cream | Cost: $11.0

// Note: The order of decorators might sometimes matter depending on the logic.
// For instance, if adding milk changes the base for sugar calculation,
// the order of wrapping would reflect that.
//: [Next](@next)
