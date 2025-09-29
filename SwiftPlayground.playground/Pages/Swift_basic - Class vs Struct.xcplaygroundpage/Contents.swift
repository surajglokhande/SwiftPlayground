//: [Previous](@previous)
/*:
 # Class Vs Struct
 ### Both structures and classes in Swift can:
 
 - **Define Properties:** Store values.
 - **Define Methods:** Provide functionality.
 - **Define Subscripts:** Access values using subscript syntax.
 - **Define Initializers:** Set up their initial state.
 - **Be Extended:** Expand functionality beyond the default implementation.
 - **Conform to Protocols:** Provide standard functionality of a certain kind.
 
 ### Additional Capabilities of Classes
 
 - **Inheritance:** One class can inherit the characteristics of another.
 - **Type Casting:** Check and interpret the type of a class instance at runtime.
 - **Deinitializers:** Enable an instance of a class to free up any resources it has assigned.
 - **Reference Counting:** Allows more than one reference to a class instance.

 ## Structures and Enumerations Are Value Types in Swift
 
 **Value Types**
 - **Definition:** A value type is a type whose value is copied when it’s assigned to a variable or constant, or when it’s passed to a function.
 - **No Inheritance:** Unlike classes, structs don't support inheritance. They cannot inherit from other structs or classes, and cannot be subclassed.
 - **Initializers:** Structs automatically receive a memberwise initializer, which allows you to create instances by specifying values for each property.
 - **Default Memberwise Initializers:** Unlike classes, structs automatically get a memberwise initializer that initializes each property with the values you provide.
 */
class Demo {
    var name: String
    //    init(str: String) {
    //        self.name = str
    //    }
    //Or
    init() {
        self.name = ""
    }
}
//var d = Demo(str: "")
var d = Demo()
struct Demo2 {
    var name: String
    //    init(name: String) {
    //        self.name = name
    //    }
    //Or
    init() {
        self.name = ""
    }
}
//var d1 = Demo2(name: "")
var d1 = Demo2()
/*:
 - **Examples:** All basic types in Swift (integers, floating-point numbers, Booleans, strings, arrays, and dictionaries) are value types and are implemented as structures.
 
 **Behavior of Value Types**
 - **Copying:** Structures and enumerations are always copied when they are passed around in your code. This means that each instance is a unique copy, independent of the original.
 
 **What is the mutating Keyword?**
 
 In Swift, the mutating keyword is used with methods of value types (primarily structs and enums) to indicate that the method modifies (mutates) the instance on which it is called.
 
 - **Mutating Methods:** Since structs are value types, methods that change properties must be marked as mutating.
 
 **How It Works**
 - **Shared Memory:** Initially, both the original and the new instance share the same memory.
 - **Copy on Modification(CoM):** When one of the instances is modified, Swift creates a copy of the collection to ensure that the modification does not affect the other instance.
 */
struct Counter {
    var count = 5
    static var count2 = 5
    
    // Must use 'mutating' to modify properties
    mutating func increment() {
        count += 1
    }
    func increment2() {
        Counter.count2 += 1
    }
    
}
var counter = Counter()
//counter.count = counter.count + 1
print("before increment call: static:\(Counter.count2): mutating:\(counter.count)")
counter.increment()
counter.increment2()
print("after increment call: static:\(Counter.count2): mutating:\(counter.count)")
var counter2 = counter
print("before assign 10: static:\(Counter.count2): mutating:\(counter2.count)")
//counter.count = 8
counter2.count = 10
Counter.count2 = 10
print("after assign 10: static:\(Counter.count2): mutating:\(counter2.count): \(counter.count)")
counter.increment() // 6+1 = 7
counter2.increment() // 10+1
counter.increment2() //10+1
counter2.increment2() //11+1
print("after increament call: static:\(Counter.count2): mutating:\(counter2.count): \(counter.count)")
/*:
 Behaviour of struct type inside class type
 */
class OuterClass {
    var innerStruct: InnerStruct?
    var outerName: String = "outer"
}
struct InnerStruct {
    var innerName: String
}

var S1 = InnerStruct(innerName: "inner")
var O1 = OuterClass()
O1.innerStruct = S1
//print(S1.innerName)
//print(O1.outerName)
//print(O1.innerStruct?.innerName ?? "")
var O2 = O1
O2.outerName = "outer2"
O2.innerStruct?.innerName = "inner2"
print(O2.outerName)
print(O2.innerStruct?.innerName ?? "")
/*:
 ## Optimization for Collections in Swift
 
 **Copy-on-Write (CoW) Optimization**
 - **Definition:** Swift collections like arrays, dictionaries, and strings use a technique called Copy-on-Write (CoW) to optimize performance. Instead of making a copy immediately when a collection is assigned to a new variable or passed to a function, the collection shares its memory with the original instance. A copy is made only when one of the instances is modified.
 
 ## Classes Are Reference Types in Swift
 
 **Reference Type**
 - **Defination:** When you assign a class instance to a variable/constant or pass it to a function, you're passing a reference to the same instance, not creating a copy reference. Multiple variables can refer to the same class instance
 - **Properties:** Classes can have stored and computed properties
 - **Initialization:** Classes require initialization of all non-optional stored properties
 - **Methods:** Classes can have instance methods and type methods
 - **Inheritance:** One of the most important features of classes is inheritance. Classes can inherit properties, methods, and other characteristics from a parent class
 - **Deinitializers:** Classes can have deinitializers that are called when the instance is being deallocated
 */
/*:
 Behaviour of class type inside value type
 */
struct Person {
    var company: Company
    var personName: String
}
class Company {
    var name: String?
}
var bajaj = Company()
bajaj.name = "Bajaj"
var suraj = Person(company: bajaj, personName: "Suraj")
//var tcs = Company()
//tcs.name = "tcs"
var vaibhav = suraj//Person(company: tcs, personName: "parag")
vaibhav.company.name = "hsbc"
vaibhav.personName = "Vaibhav"

print("Suraj: \(suraj.company.name ?? "nil")")
print("Suraj: \(suraj.personName)")
print("vaibhav: \(vaibhav.company.name ?? "nil")")
print("vaibhav: \(vaibhav.personName)")

//print("vaibhav: \(bajaj)")
//print("Suraj: \(tcs)")

//**Value Types (Structures):**
struct FixedLengthStruct {
    var firstValue: Int
    let length: Int
}
var s1 = FixedLengthStruct(firstValue: 1, length: 2)
let s2 = FixedLengthStruct(firstValue: 3, length: 4)
var s3 = s2

s1.firstValue = 10
//s1.length = 20 //Cannot assign to property: 'length' is a 'let' constant

//s2.firstValue = 30 //Cannot assign to property: 's2' is a 'let' constant
//s2.length = 40 //Cannot assign to property: 'length' is a 'let' constant

s3.firstValue = 50
//s3.length = 60 //Cannot assign to property: 'length' is a 'let' constant
/*:
 Behaviour of class type inside value type(tuple)
 Same work with above example
 */
class MyClass {
    var value: Int = 0
}

var myObject = MyClass()
myObject.value = 10

var myTuple = (intValue: 5, refValue: myObject) // refValue holds a reference to myObject

var copiedTuple = myTuple // copiedTuple now also holds a reference to the same myObject

copiedTuple.intValue = 20 // Changes only copiedTuple's intValue

copiedTuple.refValue.value = 30 // Changes the value of the object that both tuples reference

print(myTuple.intValue)       // Output: 5 (unchanged)
print(myTuple.refValue.value)  // Output: 30 (changed because both tuples reference the same object)

print(copiedTuple.intValue)    // Output: 20
print(copiedTuple.refValue.value) // Output: 30
/*:
 Reference Types (Classes):
 */
class FixedLengthClass {
    var firstValue: Int = 0
    let length: Int = 0
}
var c1 = FixedLengthClass()
let c2 = FixedLengthClass()
var c3 = c2

c1.firstValue = 10
//c1.length = 20 //Cannot assign to property: 'length' is a 'let' constant

c2.firstValue = 30
//c2.length = 40 //Cannot assign to property: 'length' is a 'let' constant

c3.firstValue = 50
//c3.length = 60 //Cannot assign to property: 'length' is a 'let' constant
print("\(c1.firstValue):\(c2.firstValue):\(c3.firstValue)")
//: [Next](@next)
