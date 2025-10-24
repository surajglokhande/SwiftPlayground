//: [Previous](@previous)
/*:
 - The Hashable protocol in Swift enables efficient storage and retrieval of custom types within hash-based data structures like Set and Dictionary.
 
 **How Hashable works for efficiency:**
 - **Hash Value Generation:** When a type conforms to Hashable, it must provide a way to generate a hashValue (or implement hash(into:)). This hashValue is an integer that serves as a unique identifier for equal instances of that type. For example, two String instances containing the same characters will produce the same hashValue.
 */
import Foundation
struct Employee: Hashable {
    var id: Int
    var name: String
}

var emp1 = Employee(id: 1, name: "John")
var emp2 = Employee(id: 2, name: "John")

debugPrint(emp1.hashValue)
debugPrint(emp2.hashValue)
//debugPrint(emp1 == emp2)
//: [Next](@next)
