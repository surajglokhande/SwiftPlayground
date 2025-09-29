//: [Previous](@previous)
/*:
 ## TaskGroup: Managing a Dynamic Set of Concurrent Tasks
 
 A TaskGroup is a more structured way to manage a collection of related, concurrent tasks. It's particularly useful when you have a dynamic number of tasks you want to launch and collect results from.

 **Key Characteristics:**

 - **Structured Concurrency (Stronger):** All tasks added to a TaskGroup are child tasks of the group. If the group's parent task is cancelled, all tasks within the group are cancelled. The group also ensures that all child tasks complete (or are cancelled) before the withTaskGroup block exits.
 - **Dynamic Creation:** You can add tasks to a TaskGroup dynamically within a loop or based on conditions.
 - **Collecting Results:** You can await the results of individual tasks within the group as they complete, or collect them into a collection.
 - **Error Propagation:** If any task within the group throws an error, that error can be propagated out of the withTaskGroup block.
 - **add(priority:operation:):** This method is used to add new child tasks to the group.
 
 **When to use TaskGroup:**

 - When you need to perform multiple, independent asynchronous operations concurrently, and you need to wait for all of them to complete or collect their results.
 - When the number of concurrent operations is not fixed at compile time (e.g., processing all items in an array, fetching data for a list of URLs).
 - When you want robust error handling and cancellation for a set of related tasks.
 */
// A helper async function
import Foundation
func processItem(_ item: String) async throws -> String {
    print("Processing \(item)...")
    let delay = Double.random(in: 1.0...3.0) // Simulate variable work
    try await Task.sleep(for: .seconds(delay))
    print("Finished processing \(item).")
    return "Result for \(item)"
}

func processMultipleItemsConcurrently() async {
    let itemsToProcess = ["Apple", "Banana", "Cherry", "Date"]
    var collectedResults: [String] = []

    print("Starting processing of multiple items concurrently...")

    do {
        // withTaskGroup creates a new task group
        // The Result type is what each child task returns.
        // The GroupResult type is what the withTaskGroup block itself returns.
       try await withThrowingTaskGroup(of: String.self) { group in
            for item in itemsToProcess {
                // Add a new child task to the group for each item
                // Each 'processItem' will run concurrently
                group.addTask {
                    return try await processItem(item)
                }
            }
            // Iterate over the results as they complete
            // This loop awaits each child task's result
            for try await result in group {
                print("Collected: \(result)")
                collectedResults.append(result)
            }
        }
        
        print("All items processed. Final results: \(collectedResults.sorted())")

    } catch {
        print("An error occurred during task group processing: \(error.localizedDescription)")
    }
}

// Kick off the concurrent processing
Task {
    await processMultipleItemsConcurrently()
    print("Concurrent processing task finished.")
}

// Keep the program running for a bit
DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
    print("Program ending.")
}
RunLoop.current.run()
//Output:
//Starting processing of multiple items concurrently...
//Processing Apple...
//Processing Banana...
//Processing Cherry...
//Processing Date...
//Finished processing Apple.
//Collected: Result for Apple
//Finished processing Date.
//Collected: Result for Date
//Finished processing Cherry.
//Collected: Result for Cherry
//Finished processing Banana.
//Collected: Result for Banana
//All items processed. Final results: ["Result for Apple", "Result for Banana", "Result for Cherry", "Result for Date"]
//Concurrent processing task finished.
//Program ending.

//: ![](concurrency.png)
/*:
 Here's a breakdown of their differences:

 **async let**

 - **Fixed Number of Tasks:** You use async let when you know the exact number of asynchronous operations you need to perform at compile time.
 - **Heterogeneous Return Types:** Each async let can declare a different type for its result. This means you can easily kick off different async functions that return different data types.
 - **Readability:** For a small, fixed number of independent tasks, async let offers a very concise and readable syntax.
 - **Immediate Start:** The task associated with an async let begins executing as soon as it's declared, in parallel with the rest of your code.
 - **Awaiting Results:** You await the individual async let variables later in your code when you need their results. This will pause the current task until that specific async let task completes.
 - **Implicit Structured Concurrency**: async let creates a child task that is implicitly structured within the parent task's scope. This means if the parent task is cancelled, the async let child tasks will also be cancelled.
 
 **TaskGroup**

 - **Dynamic Number of Tasks:** TaskGroup is ideal when you have a variable or unknown number of asynchronous operations to perform at runtime (e.g., fetching images from a list of URLs that you get dynamically).
 - **Homogeneous Return Types (Typically):** All tasks added to a single TaskGroup usually return the same type. You can iterate over the group to collect results of that common type. While you can use Any or a protocol to handle different types, it often adds complexity.
 - **Manual Task Addition:** You explicitly add tasks to the TaskGroup using group.addTask { ... }.
 - **Flexible Result Collection:** You can iterate over the TaskGroup as an AsyncSequence to process results as they become available, rather than waiting for all of them to complete simultaneously. This is useful for streaming results or handling partial failures.
 - **Granular Cancellation and Error Handling:** TaskGroup provides more control over cancellation (e.g., group.cancelAll()) and error propagation. If a child task in a ThrowingTaskGroup throws an error, the error is propagated out of the group, and other tasks in the group are implicitly cancelled.
 - **More Boilerplate:** Compared to async let, TaskGroup requires more setup code (e.g., withTaskGroup, group.addTask, looping to collect results).
 

    ### **Here's a text-based summary of the key differences between async let and TaskGroup:**

    **Task Count:** With async let, the number of tasks is fixed and known at compile time. In contrast, TaskGroup handles a dynamic number of tasks that can vary at runtime.

    **Result Types:** async let can handle heterogeneous result types, meaning each async let can return a different kind of data. TaskGroup typically works with homogeneous result types, where all tasks within the group return the same type.

    **Syntax:** async let offers a concise and direct syntax for launching concurrent operations. TaskGroup is more verbose, requiring the use of closures and explicit addTask calls.

    **Flexibility:** async let is less flexible for scenarios involving a variable number of tasks or advanced control. TaskGroup provides high flexibility for dynamic task management, including fine-grained control over cancellation.

    **Error Handling:** With async let, errors from individual tasks are propagated when you await their results. For TaskGroup, an error from any child task will cancel the entire group and propagate the error outwards.

    **Use Case:** Choose async let when you need to run a few independent tasks in parallel and know them beforehand. Opt for TaskGroup when you need to manage a collection of potentially many, similar tasks dynamically.
 
 **When to Choose Which:**

 - **Use async let when:**
    - You have a fixed, small number of independent asynchronous operations.
    - The return types of these operations might be different.
    - You want a clean and direct syntax.
    - You need to await all results before proceeding.
 
 
 - **Use TaskGroup when:**
    - You have a dynamic or unknown number of asynchronous operations.
    - The tasks often return the same type.
    - You need fine-grained control over cancellation or error handling for individual tasks within a group.
    - You want to process results as they become available (e.g., streaming).
 */
//: [Next](@next)
