//: [Previous](@previous)
/*:
 
 ## Box Class
 - used to wrap a value type (like a struct or enum) within a reference type (a class). This is useful in situations where you need reference semantics for a value.
 - "Box Class Type" in Context is the underlying mechanism of existential containers: The way Swift internally wraps value types when they are used as any Protocol types, effectively giving them reference-like behavior.
 - In modern Swift, with the introduction of any (for existential types) and some (for opaque types), the need to manually create "boxM classes" has decreased
 
 **What is "Boxing" in Swift?**
 
 - "Boxing" is the process of wrapping a value type (like a struct) inside a reference type (like a class or an "existential container") so that it can be treated as a reference. This is often necessary in scenarios where:

 **1. Objective-C Interoperability:**
 - Objective-C APIs primarily deal with objects (reference types). If you want to pass a Swift value type to an Objective-C method that expects an id or NSObject*, Swift will implicitly box it into an Any type (which can represent any type, including value types, and can bridge to id). Historically, in Swift 2, you might have had to manually create a Box class to wrap a struct for Objective-C APIs.
  */
// Example of a manual Box class (less common now with Swift's Any)
// MARK: - The Generic Box Class
class Box<T> {
    var value: T
    init(value: T) {
        self.value = value
    }
}

struct MyStruct {
    var name: String
}

let myStructInstance = MyStruct(name: "Hello")

// If you needed to pass myStructInstance to an Objective-C API
// that only accepts objects, you might have done this in older Swift versions:
// let boxedStruct = Box(value: myStructInstance)
// someObjectiveCMethod(boxedStruct)
//-------------------------------------------------------------------------

// MARK: - Example Usage with a Struct

struct MyValueType {
    var name: String
    var age: Int
}

// 1. Create an instance of your value type
var originalValue = MyValueType(name: "Alice", age: 30)
print("Original Value before boxing: \(originalValue.name), \(originalValue.age)") // Alice, 30

// 2. "Box" the value type
let boxedValue = Box(value: originalValue) // boxedValue is now a reference type

// 3. Create another reference to the *same* boxed instance
let anotherReferenceToBoxedValue = boxedValue

// 4. Modify the value *through one of the references*
anotherReferenceToBoxedValue.value.name = "Bob"
anotherReferenceToBoxedValue.value.age = 40

// 5. Observe that the change is reflected through the original box reference
print("Boxed Value after modification (through original reference): \(boxedValue.value.name), \(boxedValue.value.age)") // Bob, 40

print("anotherReferenceToBoxed Value after modification: \(anotherReferenceToBoxedValue.value.name), \(anotherReferenceToBoxedValue.value.age)") // Bob, 40

// 6. Observe that the *original unboxed* value type remains unchanged (because it was copied into the box)
print("Original unboxed value after modification: \(originalValue.name), \(originalValue.age)") // Alice, 30
/*:
 **2. Protocol Existential Types (any Protocol):**
 - When you use a protocol as a type (e.g., let shapes: [any Shape]), you're essentially saying "this array can hold any type that conforms to Shape." Since the compiler doesn't know the concrete size of each Shape at compile time (as they could be different structs or classes), Swift "boxes" these values into what's called an existential container. This container has a fixed size and stores either the value directly (for small value types) or a reference to the value allocated on the heap (for larger value types). This indirection incurs a performance cost.
 */
protocol Shape {
    func draw() -> String
}

struct Triangle: Shape {
    var size: Int
    func draw() -> String { "Triangle of size \(size)" }
}

struct Square: Shape {
    var side: Int
    func draw() -> String { "Square of side \(side)" }
}

let shapes: [any Shape] = [Triangle(size: 3), Square(side: 5)]
// Here, Triangle and Square (value types) are "boxed" into existential containers
// within the array because the array holds 'any Shape'.
/*:
 **The Purpose of a Box Class**

 - You'd create a Box Class when you have a value type (struct or enum) but need it to behave like a reference type in certain situations. Common scenarios include:

 - **Ensuring Reference Semantics:** When you want multiple variables to point to and modify the same instance of a struct. This is less common because if you truly need reference semantics, you might consider making your type a class from the start.
 - **Holding a Value Type in a Collection that Requires Reference Types (Less Common Now):** Historically, some Objective-C APIs or older Swift patterns might have required collections of NSObject subclasses. If you wanted to store structs in such a collection, you'd box them. Modern Swift's Any type and protocol existentials often handle this implicitly now.
 - **Breaking Strong Reference Cycles (Rarely the Primary Use Case):** While a Box Class can technically be used in complex scenarios involving weak references to break retain cycles, it's not its main purpose and often there are better, more direct solutions (like weak or unowned directly on class properties).
 - **Specific Design Patterns (e.g., Command Pattern, Observer Pattern):** Where you might need to pass around mutable state that is fundamentally a value type, but the pattern expects reference semantics.
 
 **When is a Box Class Less Necessary in Modern Swift?**

 - With advancements in Swift, the explicit need for a custom "Box Class" has diminished for many common scenarios:

 - Any and AnyObject: Swift's Any type can hold any type, including value types. When a value type is assigned to Any, Swift implicitly "boxes" it into an existential container.
 */
let myStruct = MyValueType(name: "Charlie", age: 25)
let anyValue: Any = myStruct // myStruct is implicitly boxed
if let unboxedValue = anyValue as? MyValueType {
    print("Unboxed from Any: \(unboxedValue.name)")
}
/*:
  - Protocol Existential Types (any Protocol): Similar to Any, when you declare a variable or collection that holds types conforming to a protocol (e.g., let collection: [any MyProtocol]), Swift uses existential containers to "box" value types that conform to that protocol.
*/
protocol Drawable {
    func draw()
}
struct Circle: Drawable {
    func draw() { print("Drawing Circle") }
}
let shapesDraw: [any Drawable] = [Circle()] // Circle (struct) is boxed
/*:
 - Passing Value Types to Objective-C: Swift handles bridging value types to Objective-C types (like NSNumber, NSString, NSArray, NSDictionary) implicitly. For custom structs, Swift often boxes them into NSValue if the type is Codable or if there's a specific bridging mechanism.
 */
//: [Next](@next)
