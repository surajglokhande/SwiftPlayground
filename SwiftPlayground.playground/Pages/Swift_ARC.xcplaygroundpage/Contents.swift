//: [Previous](@previous)
/*:
 ## How Automatic Reference Counting (ARC) Works

 Automatic Reference Counting (ARC) is a memory management system used by Swift (and Objective-C) to automatically handle memory allocation and deallocation for class instances. Its primary goal is to prevent memory leaks (memory that's no longer used but isn't freed) and dangling pointers (trying to access memory that has already been freed).

 **Here's a breakdown of its mechanism:**

 **Memory Allocation:** Every time you create a new instance of a class, ARC allocates a block of memory to store that instance's data (its type and stored property values).

 **Reference Counting:** ARC keeps a count of how many "strong references" currently point to a particular class instance.

 **Strong References:** When you assign a class instance to a property, constant, or variable, that variable creates a strong reference to the instance. This strong reference "holds onto" the instance, preventing ARC from deallocating it.

 **Deallocation:** An instance is only deallocated (its memory is freed up) when its strong reference count drops to zero. As long as at least one strong reference exists, the instance remains in memory and is accessible.

 **Preventing Crashes:** This system ensures that an instance is never deallocated while it's still being used, thereby preventing crashes that would occur if you tried to access properties or methods of a non-existent instance.

 In essence, ARC automates the process of determining when a class instance is no longer needed, allowing developers to focus on writing application logic rather than manual memory management.
 
    Example in Swift
 */
class Person {
    let name: String
    init(name: String) {
        self.name = name
        print("\(name) is being initialized")
    }
    deinit {
        print("\(name) is being deinitialized")
    }
}

var reference1: Person?
var reference2: Person?
var reference3: Person?

// 1. Create an instance and assign it to reference1.
// Strong reference count for "Alice" instance: 1
print("--- Step 1 ---")
reference1 = Person(name: "Alice")

// 2. Assign the same instance to reference2.
// Strong reference count for "Alice" instance: 2
print("--- Step 2 ---")
reference2 = reference1

// 3. Assign the same instance to reference3.
// Strong reference count for "Alice" instance: 3
print("--- Step 3 ---")
reference3 = reference1

// 4. Set reference1 to nil.
// Strong reference count for "Alice" instance: 2
print("--- Step 4 ---")
reference1 = nil

// 5. Set reference2 to nil.
// Strong reference count for "Alice" instance: 1
print("--- Step 5 ---")
reference2 = nil

// 6. Set reference3 to nil.
// Strong reference count for "Alice" instance: 0.
// ARC deallocates the "Alice" instance.
print("--- Step 6 ---")
reference3 = nil
//: [Next](@next)
