//: [Previous](@previous)
/*:
 ## Global Actors

- A special kind of actor that provides a globally unique actor instance.
- The most common global actor is MainActor, which guarantees that code marked with @MainActor (e.g., UI updates in SwiftUI/UIKit) always runs on the main thread, preventing UI inconsistencies.
  
 **Key Characteristics of Global Actors:**

 - **Single Instance:** Unlike regular actors where you create multiple instances (let myActor = MyActor()), a global actor automatically provides one and only one instance that is accessible throughout your application. You don't create it; you simply reference it.
 
 - **Global Isolation:** Any code marked with a global actor's attribute (@MyGlobalActor) is guaranteed to run on that global actor's dedicated executor, ensuring actor isolation for that code. This prevents data races on any shared state accessed within such code.
 
 - **Automatic Synthesized Instance:** The Swift compiler synthesizes a shared instance for you. For instance, the MainActor (Swift's built-in global actor) has a shared instance that runs code on the main thread.
 Reference Type: Like regular actors, global actors are reference types.

 **Defining a Global Actor:**

 You define a global actor using the @globalActor attribute on a final class or actor (though typically a final class) that contains a static shared property returning an instance of itself.
 */
import Foundation
import SwiftUI
@globalActor
actor DataStoreActor: GlobalActor        {
    // The static 'shared' property is what makes it a global actor.
    // It provides the single instance that the @DataStoreActor attribute refers to.
    static let shared = DataStoreActor()

    // Private initializer to prevent external instantiation
    private init() {
        print("DataStoreActor: Shared instance initialized.")
    }

    // Example isolated state
    var cachedData: [String: Any] = [:]

    // Isolated methods
    func saveData(_ key: String, value: Any) {
        cachedData[key] = value
        print("DataStoreActor: Saved '\(key)'.")
    }

    func getData(_ key: String) -> Any? {
        print("DataStoreActor: Retrieved '\(key)'.")
        return cachedData[key]
    }

    func clearCache() {
        cachedData.removeAll()
        print("DataStoreActor: Cache cleared.")
    }
}
/*:
 **Using a Global Actor:**

 Once defined, you use a global actor by applying its attribute (@DataStoreActor in our example) to:

 - **Functions or Methods:** To ensure a function or method runs on the global actor's executor.
 - **Classes:** To ensure all properties and methods of a class are isolated to the global actor (useful for delegating work to a specific global context).
 - **Properties:** To protect a specific property, making its access isolated to the global actor.
 */
// 1. A function that operates on the global actor
@DataStoreActor
func processAndStore(identifier: String, data: String) async {
    print("ProcessAndStore: Processing data for \(identifier)")
    // Synchronous access to DataStoreActor's isolated state and methods
    await DataStoreActor.shared.saveData(identifier, value: data.uppercased())
    // Simulate some async processing outside the actor's immediate task
    try? await Task.sleep(nanoseconds: 500_000_000)
    print("ProcessAndStore: Finished processing for \(identifier)")
}

// 2. A class whose methods are implicitly isolated to the global actor
@DataStoreActor
class UserDataManager {
    func loadUserData(userId: String) async -> [String: Any]? {
        print("UserDataManager: Loading data for \(userId)...")
        // Synchronous access to DataStoreActor's isolated state
        let data = await DataStoreActor.shared.getData("user_\(userId)") as? [String: Any]
        print("UserDataManager: Data for \(userId) loaded.")
        return data
    }

    func saveUserData(userId: String, userData: [String: Any]) async {
        print("UserDataManager: Saving data for \(userId)...")
        await DataStoreActor.shared.saveData("user_\(userId)", value: userData)
        print("UserDataManager: Data for \(userId) saved.")
    }
}

// 3. A property isolated to the global actor
@DataStoreActor var appSettings: [String: Any] = ["theme": "dark", "notifications": true]

struct GlobalActorDemo {
    static func main() async {
        let userManager = await UserDataManager()

        print("--- Initiating operations ---")

        // Call functions that are isolated to DataStoreActor
        Task {
            await processAndStore(identifier: "doc1", data: "hello world")
            print("GlobalActorDemo: doc1 operation done.")
        }

        Task {
            await processAndStore(identifier: "doc2", data: "swift concurrency")
            print("GlobalActorDemo: doc2 operation done.")
        }

        // Access the globally isolated property
        await Task { @DataStoreActor in
            appSettings["theme"] = "light"
        }.value // Requires await because accessing from non-isolated context
        print("GlobalActorDemo: App theme set to \(await appSettings["theme"] ?? "N/A")")


        // Call methods of a class whose methods are isolated to DataStoreActor
        Task {
            await userManager.saveUserData(userId: "user_A", userData: ["name": "Alice", "age": 30])
            let userData = await userManager.loadUserData(userId: "user_A")
            print("GlobalActorDemo: User A data: \(userData ?? [:])")
        }

        // Access the global actor's shared instance directly (requires await from non-isolated context)
        try? await Task.sleep(nanoseconds: 1_000_000_000) // Wait a bit
        print("GlobalActorDemo: Current cache size: \(await DataStoreActor.shared.cachedData.count)")

        // Clear the cache via the global actor
        await DataStoreActor.shared.clearCache()
        print("GlobalActorDemo: Cache cleared through shared instance.")

        print("--- All operations initiated ---")
        try? await Task.sleep(nanoseconds: 3_000_000_000) // Give time for tasks to complete
    }
}
Task {
    await GlobalActorDemo.main()
}
//Output:
//DataStoreActor: Shared instance initialized.
//--- Initiating operations ---
//ProcessAndStore: Processing data for doc1
//DataStoreActor: Saved 'doc1'.
//ProcessAndStore: Processing data for doc2
//DataStoreActor: Saved 'doc2'.
//GlobalActorDemo: App theme set to light
//UserDataManager: Saving data for user_A...
//DataStoreActor: Saved 'user_user_A'.
//UserDataManager: Data for user_A saved.
//UserDataManager: Loading data for user_A...
//DataStoreActor: Retrieved 'user_user_A'.
//UserDataManager: Data for user_A loaded.
//GlobalActorDemo: User A data: ["age": 30, "name": "Alice"]
//ProcessAndStore: Finished processing for doc2
//GlobalActorDemo: doc2 operation done.
//ProcessAndStore: Finished processing for doc1
//GlobalActorDemo: doc1 operation done.
//GlobalActorDemo: Current cache size: 3
//DataStoreActor: Cache cleared.
//GlobalActorDemo: Cache cleared through shared instance.
//--- All operations initiated ---
/*:
 ## Common Global Actors:

 The most prominent built-in global actor is MainActor.

 - **@MainActor:** Guarantees that code runs on the main thread. This is crucial for UI updates in frameworks like SwiftUI and UIKit, as UI elements must always be accessed from the main thread.
 */
@MainActor // This function will always run on the main thread
func updateUI() {
    // Access SwiftUI views, UIKit elements, etc.
    // This is safe because it's on the main thread.
}

class ViewModel: ObservableObject {
    @Published var message: String = "Loading..."

    // This method will automatically run on the MainActor because the class is marked
    // Or you can mark individual methods or properties
    @MainActor
    func fetchDataAndDisplay() async {
        // Simulate fetching data on a background thread
        let data = await Task.detached {
            try? await Task.sleep(nanoseconds: 2_000_000_000) // Simulate network delay
            return "Data Loaded!"
        }.value

        // Update UI-bound property directly on the MainActor
        self.message = data
    }
}
//: [Next](@next)
