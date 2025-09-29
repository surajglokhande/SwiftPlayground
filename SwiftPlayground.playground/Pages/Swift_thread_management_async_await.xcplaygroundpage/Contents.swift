//: [Previous](@previous)
/*:
 ## What are Asynchronous Sequences?
 
 Imagine you have a series of values that don't all appear at once. Instead, they arrive incrementally, perhaps from a network stream, a file being read line by line, or a continuous flow of events. A regular "synchronous" sequence would require all values to be available before you could iterate through them.
 
 An asynchronous sequence is like a regular sequence, but it allows you to iterate over these values as they become available, potentially pausing execution until the next value arrives, and then resuming without blocking the entire program. This is ideal for I/O-bound operations where your program would otherwise be idle, waiting for data.

 ## 1. What is Concurrency?

 At its heart, concurrency is about managing multiple tasks that are happening or appear to be happening at the same time. It's not necessarily about tasks executing simultaneously (that's parallelism, which requires multiple CPU cores), but rather about structuring your code so that multiple tasks can make progress independently.

 Think of it like this:

 **Sequential (Non-Concurrent):** Imagine you're baking a cake. You sift the flour, then mix the wet ingredients, then combine them, then pour into the pan, then bake. Each step must complete before the next one starts. If sifting takes a long time, everything else waits.

 **Concurrent:** Now imagine you have a few helpers. One sifts the flour. While they're doing that, another mixes the wet ingredients. You might be preheating the oven. All these activities are in progress concurrently. They don't block each other unnecessarily.

 ### Why is concurrency important in modern applications?

 **Responsiveness:** For user interfaces, you don't want the app to "freeze" while a long-running operation (like fetching data from the internet or processing a large image) is happening. Concurrency allows these operations to run in the background, keeping the UI fluid.
 
 **Efficiency/Performance:** By allowing independent tasks to run without blocking each other, you can make better use of available CPU time, potentially completing work faster, especially on multi-core processors.
 Better User Experience: Apps that feel fast and responsive are more pleasant to use.
 
 ## 2. Challenges of Concurrency

 While powerful, concurrency introduces a new set of complexities and potential pitfalls. These are some of the most common challenges:

 **Race Conditions:** This occurs when multiple threads or tasks try to access and modify shared data simultaneously. The final outcome depends on the unpredictable order in which they execute, leading to incorrect or inconsistent results.

    Two tasks try to increment a shared counter at the same time. If they both read the current value (e.g., 5), both increment it to 6, and then both write 6 back, the counter only increased by 1 instead of 2.
 
 **Deadlocks:** This happens when two or more tasks are blocked indefinitely, each waiting for the other to release a resource that it needs.

    Task A needs resource X and holds resource Y. Task B needs resource Y and holds resource X. Neither can proceed.
 
 **Data Inconsistency:** Similar to race conditions, this is about shared mutable state. If multiple tasks modify data without proper synchronization, the data can become corrupted or reflect an incorrect state.

 **Complexity:** Concurrent code is inherently harder to reason about, debug, and test because of the non-deterministic nature of execution order.

 **Priority Inversion:** A higher-priority task can be blocked by a lower-priority task if the lower-priority task holds a resource that the higher-priority task needs.
 
 ## 3. Swift's Approach to Concurrency (Overview)

 Swift's modern concurrency model, introduced in Swift 5.5, is built around the concept of Structured Concurrency. This is a significant shift from older, more error-prone approaches like manual thread management or complex callback chains.

 **Structured Concurrency aims to:**

 - Make asynchronous code look and behave more like synchronous code: This improves readability and maintainability.
 - Provide compile-time safety: The compiler helps you catch common concurrency bugs before your code even runs.
 - Manage cancellation and error propagation more effectively: Asynchronous operations often need to be cancelled, and errors need to be handled gracefully.
 Here are the key features Swift provides:

 **1. async functions and await expressions:**

 - You mark functions that perform asynchronous work with the async keyword.
 - When you call an async function, you use the await keyword. await temporarily suspends the execution of the current task until the async function completes, but crucially, it does not block the underlying thread. This allows the thread to do other work while waiting.
 - This eliminates "callback hell" and makes asynchronous code flow much more linearly.
 */
import Foundation
// 1. Mark the function that performs asynchronous work with 'async'
func fetchData(from urlString: String) async throws -> String {
    guard let url = URL(string: urlString) else {
        throw URLError(.badURL)
    }

    print("Starting data fetch from \(urlString)...")

    // Simulate a network request delay
    // This suspends the current task, but doesn't block the thread.
    try await Task.sleep(for: .seconds(2)) // Wait for 2 seconds

    // In a real app, this would be URLSession.shared.data(from: url)
    let fakeData = "This is data fetched from \(urlString) after a delay."
    print("Finished data fetch from \(urlString).")
    return fakeData
}

// 2. A function that calls an async function must also be async,
// or be in an 'async' context (like a Task).
// For top-level code or entry points, we use a Task.
//@main // This attribute creates an implicit main Task for top-level async code
struct MyApp {
    static func main() async { // main function is now async
        print("Application started.")

        let url1 = "https://www.pexels.com/photo/landscape-photography-of-snowy-mountain-1366919/"
        let url2 = "https://www.pexels.com/photo/forced-perspective-photography-of-cars-running-on-road-below-smartphone-799443/"

        do {
            // 'await' waits for the async function to complete.
            // The task is suspended here, but the thread can do other work.
            print("main start result 1")
            let result1 = try await fetchData(from: url1)
            print("Received: \(result1)")
            
            print("main start result 2")
            let result2 = try await fetchData(from: url2)
            print("Received: \(result2)")

            // You can also run tasks concurrently using 'async let' or TaskGroup
            // async let makes two tasks run concurrently
            async let result3 = fetchData(from: "https://www.pexels.com/photo/yellow-cosmos-flower-close-up-photography-1212487/")
            async let result4 = fetchData(from: "https://www.pexels.com/photo/lighthouse-during-golden-hour-1535162/")

            let combinedResults = try await (result3, result4) // await for both to complete
            print("Received concurrently: \(combinedResults.0) and \(combinedResults.1)")

        } catch {
            print("An error occurred: \(error.localizedDescription)")
        }

        print("Application finished.")
    }
}
await MyApp.main()
// Output:
// Application started.
// Starting data fetch from https://www.pexels.com/photo/landscape-photography-of-snowy-mountain-1366919/...
// Finished data fetch from https://www.pexels.com/photo/landscape-photography-of-snowy-mountain-1366919/.
// Received: This is data fetched from https://www.pexels.com/photo/landscape-photography-of-snowy-mountain-1366919/ after a delay.
// Starting data fetch from https://www.pexels.com/photo/forced-perspective-photography-of-cars-running-on-road-below-smartphone-799443/...
// Finished data fetch from https://www.pexels.com/photo/forced-perspective-photography-of-cars-running-on-road-below-smartphone-799443/.
// Received: This is data fetched from https://www.pexels.com/photo/forced-perspective-photography-of-cars-running-on-road-below-smartphone-799443/ after a delay.
// Starting data fetch from https://www.pexels.com/photo/yellow-cosmos-flower-close-up-photography-1212487/...
// Starting data fetch from https://www.pexels.com/photo/lighthouse-during-golden-hour-1535162/...
// Finished data fetch from https://www.pexels.com/photo/lighthouse-during-golden-hour-1535162/.
// Finished data fetch from https://www.pexels.com/photo/yellow-cosmos-flower-close-up-photography-1212487/.
// Received concurrently: This is data fetched from https://www.pexels.com/photo/yellow-cosmos-flower-close-up-photography-1212487/ after a delay. and This is data fetched from https://www.pexels.com/photo/lighthouse-during-golden-hour-1535162/ after a delay.
// Application finished.
//: [Next](@next)
