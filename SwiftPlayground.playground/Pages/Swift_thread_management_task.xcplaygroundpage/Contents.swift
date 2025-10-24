//: [Previous](@previous)
/*:
 ## Task
 
 - **Asynchronous Context:** A Task provides the environment where you can use await. If you have async functions you want to call from a synchronous context (like a button tap handler in UIKit or the main function of a command-line tool), you typically wrap them in a Task.
 - **Cooperative Thread Pool:** Tasks don't map directly to threads. Swift's concurrency runtime manages a pool of threads and cooperatively schedules tasks on them. When a task awaits, it suspends itself, and the thread can be used by another task. When the awaited operation completes, the task resumes.
 - **Cancellation:** Tasks are cancellable. You can call task.cancel() on a Task instance, and the task can periodically check Task.isCancelled or Task.checkCancellation() to react and stop its work gracefully.
 - **Result:** A Task can produce a result (await task.value) or throw an error.
 
 **Parent-Child Relationship (Structured Concurrency):**
 
 When you create a Task within an existing async function, it often becomes a child task. If the parent task is cancelled or finishes, its child tasks are automatically cancelled. This helps prevent "leaked" background work.
 Task.detached creates a detached task, which is an independent top-level task not tied to the lifecycle of its creation scope. Use these with caution, as their cancellation and error propagation are entirely separate.
 
 **When to use Task:**

 - To start an asynchronous operation from a synchronous context (e.g., kicking off a network request from a UI event).
 - To perform an independent piece of work that doesn't need to block the current execution flow.
 - To create a new, concurrent branch of execution.
*/
import Foundation
func performLongRunningOperation() async -> String {
    print("Long operation started... \(Thread.current)")
    try? await Task.sleep(for: .seconds(3)) // Simulate work
    print("Long operation finished. \(Thread.current)")
    return "Data from long operation \(Thread.current)"
}

// In a synchronous context (e.g., a function that's not async)
func startBackgroundWork() {
    print("Starting background work... \(Thread.current)")

    // Create a Task to run the async operation
    let backgroundTask = Task {
        let result = await performLongRunningOperation()
        print("Received result in Task: \(result) \(Thread.current)")

        // Check for cancellation (good practice)
        if Task.isCancelled {
            print("Task was cancelled! \(Thread.current)")
            return // Exit early
        }
    }

    // The main thread continues immediately
    print("Background work initiated. Main thread continues. \(Thread.current)")

    // You could potentially cancel the task later
    // backgroundTask.cancel() // Uncomment to see cancellation in action

    // Await the task's result if you need it later in an async context
     Task {
         let finalResult = await backgroundTask.result
         print("Final result awaited: \(finalResult) \(Thread.current)")
     }
}

// Call the function to demonstrate
startBackgroundWork()

// Keep the program running for a bit to see the Task complete
// In a real app, this would be handled by the app lifecycle
DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
    print("Program ending. \(Thread.current)")
}
// This is just to keep the playground/CLI running
// For a SwiftPM executable, @main struct MyApp { static func main() async { ... } } handles this.
RunLoop.current.run()
//Output:
//Starting background work...
//Background work initiated. Main thread continues.
//Long operation started...
//Long operation finished.
//Received result in Task: Data from long operation
//Program ending.
//: ![](concurrency.png)
//: [Next](@next)
