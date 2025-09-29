//: [Previous](@previous)
/*:
 ## Sendable Protocol:

 - This is a compile-time safety mechanism.
 - Types that conform to Sendable are guaranteed to be safe to pass across "concurrency domains" (e.g., between different tasks or actors).
 - Value types (structs, enums) are generally Sendable by default if their members are Sendable.
 - Classes are not Sendable by default because they are reference types and can be mutated from multiple places. You often need to protect shared class instances with actors or other synchronization mechanisms.
 
 */
import Foundation
struct UserData {
    var id: Int
    var name: String
}

func processUserData(_ data: UserData) async {
    // Simulate some asynchronous processing
    try? await Task.sleep(nanoseconds: 3_000_000_000) // Sleep for 1 second
    print("Processing user: \(data.name) with ID: \(data.id)")
}

func main() {
    let user = UserData(id: 1, name: "Alice")

    // Spawning a new task and passing the Sendable struct
    Task {
        await processUserData(user)
    }

    // The original 'user' object can still be accessed safely in the main context
    print("Main context: User ID is \(user.id)")
}

//main()

// A simple class (not Sendable, not marked as @unchecked Sendable)
class NotSendableClass {
    var value: Int
    init(value: Int) { self.value = value }
}

func runTask() {
    let obj = NotSendableClass(value: 42)
    Task.detached { [obj] in
        // ❌ This will cause a compile-time error:
        // Type 'NotSendableClass' cannot be sent between threads safely
        print(obj.value)
    }
}
runTask()
//: [Next](@next)
