/*:
 [Previous](@previous)
 # Closures
 - **Closures:** Self-contained blocks of functionality that can be passed around and used in your code. They are similar to anonymous functions, lambdas, and blocks in other programming languages.
 
 ## Capturing Values
 - **Closing Over Variables:** Closures can capture and store references to constants and variables from the context in which they’re defined. This process is known as closing over those constants and variables. Swift handles all the memory management for capturing.
 
 ## Types of Closures
 - **Global Functions:** Named closures that don’t capture any values.
 - **Nested Functions:** Named closures that can capture values from their enclosing function.
 - **Closure Expressions:** Unnamed closures written in a lightweight syntax that can capture values from their surrounding context.
*/
/*: 
 ## Trailing Closures
 - **Trailing Closures:** A syntax for writing a closure expression outside of the function call's parentheses, making the code more readable, especially for long closures.
 */
func someFunctionThatTakesAClosure(closure: (Int) -> Void) {
		// function body goes here
        closure(0)
}

// Here's how you call this function without using a trailing closure:
someFunctionThatTakesAClosure(closure: { status in
	// closure's body goes here
    print(status)
})

// Here's how you call this function with a trailing closure instead:
someFunctionThatTakesAClosure() { status in
		// trailing closure's body goes here
    print(status)
}
import Foundation
var savedRequests: [DispatchWorkItem] = []
someFunction {
    print("1")
}
func someFunction(handler: @escaping ()->()) {
    print("2")
    savedRequests.append(DispatchWorkItem {
        handler()
    })
    print("3")
}
/*:
 ## Capturing Values
 - **Capturing Values:** Closures can capture and store references to constants and variables from the context in which they are defined. This allows the closure to refer to and modify these values even after the original scope has ended.

 - **Returning Functions:** makeIncrementer returns a function (incrementer) that captures runningTotal and amount.
 - **Capturing by Reference:** The nested incrementer function captures runningTotal and amount by reference, ensuring they persist beyond the scope of makeIncrementer.
 */
func makeIncrementer(forIncrement amount: Int) -> () -> Int {
	var runningTotal = 0
	func incrementer() -> Int {
		runningTotal += amount
		return runningTotal
	}
	return incrementer
}

let incrementByTen = makeIncrementer(forIncrement: 10)
incrementByTen()
incrementByTen()
let incrementBySeven = makeIncrementer(forIncrement: 7)
incrementBySeven()
/*:
 ## Closures Are Reference Types

 **Reference Types**
 - **Definition:** Functions and closures in Swift are reference types. This means that when you assign a function or closure to a constant or variable, you are actually assigning a reference to that function or closure.
 Behavior of Constants and Variables
 - **Constants and Variables:** Even if you assign a closure to a constant, the closure itself can still modify the values it captures. The constant refers to the closure, not the contents of the closure.
 ```
 let incrementByTen = makeIncrementer(forIncrement: 10)
 incrementByTen() // returns 10
 incrementByTen() // returns 20
 ```
 **Shared References**
 - **Multiple References:** Assigning a closure to multiple constants or variables means they all refer to the same closure.
 ```
 let alsoIncrementByTen = incrementByTen
 alsoIncrementByTen() // returns 30
 incrementByTen() // returns 40
 ```
 In this example, both alsoIncrementByTen and incrementByTen refer to the same closure, so calling either of them affects the same runningTotal variable
 */
/*:
 ## Escaping Closures
 **Definition**
 - **Escaping Closures:** A closure is said to escape a function when it is passed as an argument to the function but is called after the function returns. Use the @escaping keyword to indicate that a closure is allowed to escape.

 **Capturing self**
 - **Special Consideration:** When an escaping closure captures self, it can create strong reference cycles. Explicitly capture self to avoid this.
 
 **Example with self Capture List**
 - **Capture List:** Use a capture list to explicitly capture self.
 */
var completionHandlers: [() -> Void] = []
func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
    completionHandlers.append(completionHandler)
}
someFunctionWithEscapingClosure(completionHandler: {
    
})
func someFunctionWithNonescapingClosure(closure: () -> Void) {
	closure()
}
someFunctionWithNonescapingClosure(closure: {
    
})
class SomeClass {
	var x = 10
    var y = 10
	func doSomething() {
        print("initiat")
		someFunctionWithEscapingClosure {
            print("inside")
            self.x = 100
        } //or someFunctionWithEscapingClosure { [self] in x = 100 }
		someFunctionWithNonescapingClosure {
            print("inside non escaping")
            self.y = 200
        }
        print("initiat closed")
	}
}
var s = SomeClass()
print("\(s.x):\(s.y)")
s.doSomething()
completionHandlers.first?()
print("\(s.x):\(s.y)")
/*:
 **Structures and Enumerations**
 - **Value Types:** Escaping closures cannot capture a mutable reference to self when self is a structure or enumeration.
 */

struct SomeStruct {
	var x = 10
	mutating func doSomething() {
		//someFunctionWithEscapingClosure { x = 100 } //Escaping closure captures mutating 'self' parameter
		someFunctionWithNonescapingClosure { self.x = 200 }
	}
}
let instance = SomeClass()
instance.doSomething()
print(instance.x)
	// Prints "200"
completionHandlers.first?()
print(instance.x)
	// Prints "100"


/*:
## Autoclosures
An autoclosure is a closure that’s automatically created to wrap an expression that’s being passed as an argument to a function. It doesn’t take any arguments, and when it’s called, it returns the value of the expression that’s wrapped inside of it. This syntactic convenience lets you omit braces around a function’s parameter by writing a normal expression instead of an explicit closure.

 An autoclosure lets you delay evaluation, because the code inside isn’t run until you call the closure. Delaying evaluation is useful for code that has side effects or is computationally expensive, because it lets you control when that code is evaluated.
*/
var customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
print(customersInLine.count)
	// Prints "5"

let customerProvider = { customersInLine.remove(at: 0) }

print("Now serving \(customerProvider())!")
	// Prints "Now serving Chris!"
print(customersInLine.count)
/*:	example Two
 In Swift, @autoclosure simplifies code by automatically converting an expression into a closure without needing curly braces {}. This allows for delayed execution, improving performance.
 In this example, 2 > 1 is treated as a closure due to @autoclosure, only executed when condition() is called.
 */
func printIfTrue(_ condition: @autoclosure () -> Bool) {
	if condition() {
		print("True")
	}
}
func addition(_ add: @autoclosure () -> Int) {
    print(add())
}

printIfTrue(2 > 1) // Prints "True"
addition(10 + 20)
//: [Next](@next)
